## HelloWeb3 
## Overview
This repository enables the rapid provisioning of a GKE cluster, pre-configured with Dockerfiles, monitoring, networking, and DNS services, through easily reproducible steps. However, migrating this deployment to a distinct GCP account or VPC will likely necessitate the modification of a few key values.

## Prerequisites
- API Key from polygonscan.com (it is free)  https://polygonscan.com/register
- Get Access to Google Cloud Platform (GCP) and the claim $300 free credits
    https://cloud.google.com/free/docs/gcp-free-tier/#free-trial.
- Familiarity with Terraform, Kubernetes, Docker, Helm, Prometheus, Grafana, and GitHub Actions.

## Set up

This guide assumes prior GCP signup and enablement of necessary services and APIs.
  
Before proceeding, create and record the details for these resources:

Google Cloud Setup:
- Create a new Project and record the Project ID.
- Create a Google Cloud Storage Bucket and note its unique Bucket Name.
External Services:
- Obtain an API key from a free account on polygonscan.com and save the API Key.
- Domain Configuration (via Google Cloud):
- Acquire a domain name (e.g., example.com).
- Configure two subdomains: one for the HelloWeb3 Service (e.g., helloweb3.example.com) and one for the Grafana Service (e.g., grafana.example.com). Remember the subdomain names.
Account Information:
- Make a note of the email address used for your Google Cloud Project and the domain name registration. This email will be required for the cluster issuer.

## Terraform

The Terraform files in the ./terraform directory define the infrastructure as code for setting up the core GKE cluster, VPC, service accounts, container registry and DNS. This also includes provisioning for Prometheus, Grafana, NGINX Ingress Controller and namespaces. These are all separated in the ./modules folder to keep everything tidy.

To begin, make sure you have the following prerequisites in place:

- Install the Google Cloud SDK (gcloud) and authenticate it via the CLI to your target Google Cloud Project.
- Download and install both kubectl and helm. 
- Download OpenLens (Optional)
- Install the Terraform CLI.

Once you have everything set up, move into the ./terraform directory and execute the following:
```
terraform init
```

To view what will be deployed with Terraform, execute the following:
```
terraform plan
```

Once everything is checked out, you can begin applying the terraform configuration with the following:
```
terraform apply
```
You can also do it module by module using the following argument:
```
terraform apply -target="module.<module_name>"
```

## Node.js Application

With our terraform configuration, we created our repository in the Google Container Registry (gcr) and also created the service account with the necessary permissions to upload and deploy artifacts.

Terraform automatically generates the Service Account key with the provided output, since this is sensitive information, you will need to retrieve it separately with the following command:
```
terraform output -raw gha_sa_key > key.json
cat key.json
```
NOTE: Do not push this key.json file to the repository, it contains sensitive information!

Once we have our key, we can proceed to add this key to our Github Actions secrets for our workflow to build docker and upload artifacts to GCR.

## HelloWeb3 Helm Deployment
With our Docker image pushed and GKE cluster created, the next step is to configure kubectl for cluster access via Kubeconfig.

Use these commands to configure access:

```
gcloud components install gke-gcloud-auth-plugin

gcloud container clusters get-credentials helloweb3-cluster --region=us-central1
```
You can now use Helm to install the charts in the helm/helloWeb3 directory.

# Customization:

The helm/helloWeb3/values.yaml file allows customization of deployment settings like hostnames, ports, and API key names.

Manual Installation Command:
```
helm upgrade --install helloweb3 ./helm/helloWeb3 \
--namespace helloweb3 \
--set image.repository=${{ FULL_REPOSITORY_URL }} \
--set image.tag=:$TAG
```
NOTE: this can also be deployed automatically via GitHub Actions to a pre-configured cluster.

## DNS

With the GKE cluster and Helm deployment complete, the next crucial step is to configure DNS routing in Google Cloud. This will enable the Ingress resources to function correctly and expose your services to the public internet. 

Our terraform has the necessary configurations to do this automatically, you can review this with the following:
```
terraform plan --target="module.dns"
```

# Review Kubernetes ingress
Run the following commands:
```
kubectl get ing -A
```
it should return the following values:
```
NAMESPACE    NAME                        CLASS    HOSTS                                       ADDRESS        PORTS     AGE
helloweb3    cm-acme-http-solver-vzghz   <none>   rvtest.site                                                80        15s
helloweb3    helloweb3                   nginx    *.rvtest.site,rvtest.site                   34.46.173.17   80, 443   10h
monitoring   cm-acme-http-solver-dv94t   <none>   grafana.rvtest.site                                        80        15s
monitoring   grafana                     nginx    *.grafana.rvtest.site,grafana.rvtest.site   34.46.173.17   80, 443   10h
```

To make the DNS routing work, you'll need to create A records in your Google Cloud DNS hosted zone. The key is to map each hostname to the provided IP address (34.46.173.17).

As an example, if one of your hostnames is app.randomdns....com, you'll create an A record for this hostname and set its destination IP address to 34.46.173.17 within the Google Cloud console.

After clicking "Create Record," please wait about 10 to 20 minutes.

Once the DNS is correctly set up, the Certificate Manager deployed earlier should automatically handle HTTPS/SSL for your services.
