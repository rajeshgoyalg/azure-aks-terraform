# Azure AKS Modular Terraform Project

Provision a production-ready Azure Kubernetes Service (AKS) cluster and all supporting infrastructure using a modular, maintainable, and secure Terraform setup.

---

## Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Module Descriptions](#module-descriptions)
4. [Prerequisites](#prerequisites)
5. [Authentication Setup](#authentication-setup)
6. [Usage](#usage)
7. [Variables Reference](#variables-reference)
8. [Outputs](#outputs)
9. [Security & State Management](#security--state-management)
10. [Project Structure](#project-structure)
11. [License & Contributions](#license--contributions)

---

## Project Overview
This project provisions:
- An Azure Kubernetes Service (AKS) cluster
- Azure Virtual Network and Subnet
- User-assigned Managed Identity
- Log Analytics Workspace and Container Insights for monitoring
- All resources are modularized for reusability and clarity

## Architecture
```
+-------------------+
|  resource_group   |
+-------------------+
         |
         v
+-------------------+
|     network       |---+--> [Virtual Network]
+-------------------+   |
         |              +--> [Subnet]
         v
+-------------------+
|     identity      |--> [User-assigned Managed Identity]
+-------------------+
         |
         v
+-------------------+
|       aks         |--> [AKS Cluster]
|                   |--> [Log Analytics Workspace]
|                   |--> [Container Insights]
+-------------------+
```

## Module Descriptions
- **resource_group**: Creates the Azure Resource Group.
- **network**: Provisions a Virtual Network and Subnet for AKS.
- **identity**: Creates a User-assigned Managed Identity for secure resource access.
- **aks**: Deploys the AKS cluster, default node pool, and monitoring resources.

## Prerequisites
- [Terraform CLI](https://learn.hashicorp.com/terraform/getting-started/install.html) >= 1.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure subscription with sufficient permissions
- (Recommended) Python 3 and virtualenv for environment isolation

## Authentication Setup
Login with Azure CLI:
```bash
az login
az account set --subscription <your-subscription-id>
```

Or use a Service Principal:
```bash
az ad sp create-for-rbac --name "terraform-sp" --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
export ARM_CLIENT_ID=...
export ARM_CLIENT_SECRET=...
export ARM_SUBSCRIPTION_ID=...
export ARM_TENANT_ID=...
```

## Usage
**1. Clone and enter the project directory:**
```bash
git clone <this-repo-url>
cd azure-aks-terraform
```

**2. Install Terraform providers:**
```bash
terraform init
```

**3. Preview the infrastructure changes:**
```bash
terraform plan
```

**4. Apply to deploy resources:**
```bash
terraform apply
```

**5. Destroy resources (if needed):**
```bash
terraform destroy
```

## Variables Reference
| Variable Name              | Type         | Default                        | Description                                 |
|----------------------------|--------------|--------------------------------|---------------------------------------------|
| resource_group_name        | string       | "rg-aks-microservices-poc"     | Name of the Azure Resource Group            |
| location                   | string       | "eastus"                       | Azure region to deploy resources            |
| aks_cluster_name           | string       | "aks-microservices-poc-cluster"| Name of the AKS cluster                     |
| vnet_address_space         | list(string) | ["10.10.0.0/16"]               | Address space for the Virtual Network       |
| aks_subnet_address_prefix  | list(string) | ["10.10.1.0/24"]               | Address prefix for the AKS subnet           |
| aks_node_count             | number       | 2                              | Number of nodes in the default node pool    |
| aks_vm_size                | string       | "Standard_B2ms"                | VM size for AKS nodes                       |
| kubernetes_version         | string       | null                            | Kubernetes version for AKS                  |
| tags                       | map(string)  | see variables.tf                | Tags to apply to all resources              |

See `variables.tf` and each module's `variables.tf` for full details.

## Outputs
| Output Name                | Description                                         |
|---------------------------|-----------------------------------------------------|
| resource_group_name        | Name of the Azure Resource Group                    |
| aks_cluster_name           | Name of the AKS cluster                             |
| kube_config                | Raw kubeconfig for kubectl (sensitive)              |
| aks_identity_principal_id  | Principal ID of the AKS managed identity            |

## Security & State Management
- **State:** For production, configure [remote state](https://www.terraform.io/docs/language/state/remote.html) (e.g., Azure Storage Account) to protect and share state securely.
- **Sensitive Files:** `.terraform/`, `terraform.tfstate*`, and other sensitive files are git-ignored by default.
- **Credentials:** Never commit credentials or secrets. Use environment variables or Azure Key Vault.

## Project Structure
```
azure-aks-terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── modules/
│   ├── aks/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── identity/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── network/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── resource_group/
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── .gitignore
├── README.md
└── terraform.tfstate*
```

## License & Contributions
Contributions are welcome! Please open issues or pull requests for improvements.

Licensed under the MIT License.
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
kubectl apply -f demo-flask-app/aks_service.yaml
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

