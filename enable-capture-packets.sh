#!/bin/bash
set -x

##############################
##### START - VARIABLES ######
##############################

SUBSCRIPTION_NAME="airs-for-pinhuang"
LOCATION="eastus"
RESOURCEGROUP="rg-aro"
VM_NAME="vm-aro-win"
STORAGE_ACCOUNT_NAME="raenerator123csadq"
CAPTURE_NAME=$(date "+%Y%m%d%H%M%S"-$VM_NAME)
DURATION="60"
FILE_NAME=

# $(date "+%Y%m%d%H%M%S"-$VM_NAME)

##############################
##### END - VARIABLES ######
##############################

# az storage account create \
#   --name $STORAGE_ACCOUNT_NAME \
#   --resource-group $RESOURCEGROUP \
#   --location $LOCATION \
#   --sku Standard_LRS \
#   --kind StorageV2


# Start packet capture
az network watcher packet-capture create \
  --name $CAPTURE_NAME \
  --resource-group $RESOURCEGROUP \
  --storage-account $STORAGE_ACCOUNT_NAME \
  --vm $VM_NAME \
  --file-path "$CAPTURE_NAME.cap" \
  --time-limit $DURATION

az network watcher packet-capture show-status \
  --name $CAPTURE_NAME \
  --resource-group $RESOURCEGROUP \
  --location $LOCATION

sleep 60

  az network watcher packet-capture show-status \
  --name $CAPTURE_NAME \
  --resource-group $RESOURCEGROUP \
  --location $LOCATION