#!/bin/bash
set -x

##############################
##### START - VARIABLES ######
##############################

SUBSCRIPTION_NAME="airs-for-pinhuang"
LOCATION="eastus"
RESOURCEGROUP="rg-aro"
VM_NAME="vm-aro-win"


##############################
##### END - VARIABLES ######
##############################

##############################
####### START - SCRIPT #######
##############################

NIC_NAME=$(az vm show -n vm-aro-win -g rg-aro --query '[networkProfile.networkInterfaces][].id' -otsv | cut -d'/' -f9)

IPCONFIG_NAME=$(az network nic ip-config list \
  --resource-group $RESOURCEGROUP \
  --nic-name $NIC_NAME \
  --query '[].name' \
  --out tsv)

IpConfigId=$(az network nic ip-config show \
  --name $IPCONFIG_NAME \
  --nic-name $NIC_NAME \
  --resource-group $RESOURCEGROUP \
  --query id \
  --out tsv)

SUBSCRIPTION_ID=$(az account show \
  --name $SUBSCRIPTION_NAME \
  --query id \
  --out tsv)

az feature register \
  --namespace Microsoft.Network \
  --name AllowVirtualNetworkTap

sleep 30

az feature show \
  --namespace Microsoft.Network \
  --name AllowVirtualNetworkTap

az provider register \
  --namespace Microsoft.Network \
  --subscription $SUBSCRIPTION_ID

az network vnet tap create \
  --resource-group $RESOURCEGROUP \
  --name vtap \
  --destination $IpConfigId \
  --port 4789 \
  --location $LOCATION
