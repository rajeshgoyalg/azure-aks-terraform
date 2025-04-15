# 🚀 Azure AKS Cluster Setup with Terraform & Microservices Deployment via Docker & Kubernetes

This guide walks you through the complete process of provisioning an Azure Kubernetes Service (AKS) cluster using Terraform, configuring access via `kubectl`, and deploying microservices with Kubernetes manifests. Docker images are assumed to be pre-pushed to Docker Hub.

---

## 📑 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Azure Setup](#azure-setup)
3. [Terraform AKS Provisioning](#terraform-aks-provisioning)
4. [Configure kubectl](#configure-kubectl)
5. [Deploy Microservices with Kubernetes](#deploy-microservices-with-kubernetes)
6. [Verify and Test](#verify-and-test)
7. [Troubleshooting](#troubleshooting)
8. [References](#references)

---

## ✅ Prerequisites

Ensure the following are installed and configured:

- An Azure account with necessary permissions.
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) (`az login`)
- [Terraform](https://developer.hashicorp.com/terraform/install)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/intro/install/) (for NGINX Ingress Controller)
- Docker images pushed to Docker Hub (replace image placeholders in manifests accordingly)

---

## 🔧 Azure Setup

### 1. Install and Login to Azure CLI

`az login`

This opens a browser window for authentication.
### 2. Set Active Subscription
If you have multiple subscriptions:
```
az account list --output table
az account set --subscription "<your-subscription-id>"
```
### 3. Register Required Resource Providers
```
az provider register --namespace Microsoft.OperationsManagement
az provider register --namespace Microsoft.OperationalInsights
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.DocumentDB
az provider register --namespace Microsoft.AVS
```
# Optional: verify registration
`az provider show -n Microsoft.ContainerService -o table`

### 📦 Terraform AKS Provisioning

Navigate to your Terraform directory and run:
```
terraform init
terraform plan
terraform apply --auto-approve
```
### 📁 Configure kubectl

## 1. Retrieve kubeconfig
`terraform output -raw kube_config > ~/.kube/aks_poc_config`
⚠️ Note: This will overwrite the file if it already exists.
## 2. Set KUBECONFIG Environment Variable
`export KUBECONFIG=~/.kube/aks_poc_config`
Windows (CMD): set KUBECONFIG=%USERPROFILE%\.kube\aks_poc_config
Windows (PowerShell): $env:KUBECONFIG = "$env:USERPROFILE\.kube\aks_poc_config"

## 3. Verify Cluster Access
`kubectl get nodes`

### 🚢 Deploy Microservices with Kubernetes

## 1. Install NGINX Ingress Controller (via Helm)

`helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx`
`helm repo update`

```
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.replicaCount=2 \
  --set controller.nodeSelector."kubernetes\.io/os"=linux \
  --set defaultBackend.nodeSelector."kubernetes\.io/os"=linux \
  --set controller.admissionWebhooks.patch.nodeSelector."kubernetes\.io/os"=linux
```
## Check pod and load balancer status:
```
kubectl get pods -n ingress-nginx
kubectl get service ingress-nginx-controller -n ingress-nginx -o wide
```
## 2. Deploy Your Microservices
Clone the manifests repo:
`git clone https://github.com/rajeshgoyalg/demo-kubernetes-configs`
`cd demo-kubernetes-configs`

## Apply resources:
```
kubectl apply -f demo-flask-app/deployment.yaml
kubectl apply -f demo-flask-app/service.yaml
kubectl apply -f demo-flask-app/aks_ingress.yaml
```
## ✅ Verify and Test

Check resources:
```
kubectl get deployments
kubectl get pods
kubectl get services
kubectl get ingress
```
Retrieve External IP of NGINX Ingress Controller:
```
kubectl get service ingress-nginx-controller -n ingress-nginx \
  --output=jsonpath='{.status.loadBalancer.ingress[0].ip}'
```
Test your service:
`curl http://<EXTERNAL-IP>/`
## 🧰 Troubleshooting

- No External IP? Wait a few minutes after creating the ingress controller.
- Cluster not responding? Ensure KUBECONFIG is set correctly.
- Ingress not routing properly? Validate your DNS and service configurations.

