#!/bin/bash

# Variables
resourceGroup="acdnd-c4-project"
clusterName="udacity-cluster"

nameACR="myacr202111"
location="westus2"

# For Cloud Lab
resourceGroup=$(az group list --query "[0].name" -o tsv)

# For Cloud Lab users, go to the existing Log Analytics workspace --> General-> Properties --> Resource ID. Copy it and use in the command below.

resourceID="/subscriptions/62d70a26-cec0-4efb-878f-bb4ba7135ee6/resourcegroups/cloud-demo/providers/microsoft.operationalinsights/workspaces/loganalytics-164333"

echo "Cloud Lab resource group: $resourceGroup"

# Install aks cli
# echo "Installing AKS CLI"

# az aks install-cli

# echo "AKS CLI installed"

# Create AKS cluster
echo "Step 1 - Creating AKS cluster $clusterName"
# Use either one of the "az aks create" commands below
# For users working in their personal Azure account
# This commmand will not work for the Cloud Lab users, because you are not allowed to create Log Analytics workspace for monitoring
# az aks create \
# --resource-group $resourceGroup \
# --name $clusterName \
# --node-count 1 \
# --enable-addons monitoring \
# --generate-ssh-keys

# For Cloud Lab users
az aks create \
--resource-group $resourceGroup \
--name $clusterName \
--node-count 1 \
--generate-ssh-keys \
--resource-group $resourceGroup \
--location $location

# For Cloud Lab users
# This command will is a substitute for "--enable-addons monitoring" option in the "az aks create"

az aks enable-addons -a monitoring -n $clusterName -g $resourceGroup --workspace-resource-id $resourceID

echo "AKS cluster created: $clusterName"

# Connect to AKS cluster

echo "Step 2 - Getting AKS credentials"

az aks get-credentials \
--resource-group $resourceGroup \
--name $clusterName \
--verbose

echo "Verifying connection to $clusterName"

kubectl get nodes

# echo "Deploying to AKS cluster"
# The command below will deploy a standard application to your AKS cluster. 
# kubectl apply -f azure-vote.yaml