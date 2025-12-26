# AKS Workload Identity + ACR Setup (Pre-requisites)

This document describes the **minimal, correct, and production-ready** steps to prepare Azure, ACR, AKS, and Managed Identity for **AKS Workload Identity**–based authentication (no secrets).

---

## 1. Azure Provider Registration (One-time)

Register only the required providers at the **subscription level**.

```bash
az provider register --namespace Microsoft.Network
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.ContainerRegistry
az provider register --namespace Microsoft.OperationalInsights
az provider register --namespace Microsoft.Insights
az provider register --namespace Microsoft.Compute
```

Optional (only if used):

```bash
az provider register --namespace Microsoft.DBforPostgreSQL
az provider register --namespace Microsoft.Cache
az provider register --namespace Microsoft.OperationsManagement
```

Verify:

```bash
az provider show --namespace Microsoft.ContainerService --query registrationState
```

## 2. Azure Container Registry (ACR) – Build & Push Image

```bash
az login
az acr login --name aksvotingapp

docker build -t voting-app:latest .

docker tag voting-app:latest aksvotingapp.azurecr.io/voting-app:v1

docker push aksvotingapp.azurecr.io/voting-app:v1
```

Verify:

```bash
az acr repository list --name aksvotingapp -o table
az acr repository show-tags --name aksvotingapp --repository voting-app -o table
```

3. Create User-Assigned Managed Identity

```bash
az identity create \
  -g <resource-group> \
  -n demo-pod-mi
```

Capture identity details:

```bash
az identity show \
  -g <resource-group> \
  -n demo-pod-mi \
  --query "{clientId:clientId, principalId:principalId, id:id}"
```
4. Assign RBAC Permissions
Allow AKS pods to pull images from ACR

```bash
az role assignment create \
  --assignee <MI_CLIENT_ID> \
  --role AcrPull \
  --scope $(az acr show -n aksvotingapp --query id -o tsv)
```

5. Enable AKS OIDC Issuer & Workload Identity
Check status:

```bash
az aks show \
  -g <resource-group> \
  -n aks-cluster \
  --query "oidcIssuerProfile.enabled"
```
Enable if required:

```bash
az aks update \
  -g <resource-group> \
  -n aks-cluster \
  --enable-oidc-issuer \
  --enable-workload-identity
```
6. Create Federated Identity Credential
Get AKS OIDC issuer URL
```bash
AKS_ISSUER=$(az aks show \
  -g <resource-group> \
  -n <cluster-name> \
  --query oidcIssuerProfile.issuerUrl \
  -o tsv)
```
Create federation
```bash
az identity federated-credential create \
  --name demo-federation \
  --identity-name <managed-identity-name> \
  --resource-group <resource-group> \
  --issuer "$AKS_ISSUER" \
  --subject system:serviceaccount:demo:demo-sa \
  --audience api://AzureADTokenExchange
```

Important:
The subject must exactly match namespace:serviceaccount.

7. Kubernetes ServiceAccount
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: demo-sa
  namespace: demo
  annotations:
    azure.workload.identity/client-id: <MI_CLIENT_ID>
```

Apply:

```bash
kubectl apply -f sa.yaml
```

8. Pod / Deployment Requirements
Your workload must reference the ServiceAccount and include the label:

```yaml
spec:
  serviceAccountName: demo-sa
```
```yaml
metadata:
  labels:
    azure.workload.identity/use: "true"
```
Without this label, token injection will not occur.

