#!/bin/bash
set -o allexport
source .env
set +o allexport

echo "Onpremise VM 資訊"
ONPREM_VM_PRIVATE_IP=$(az vm list-ip-addresses \
    --resource-group $RESOURCE_GROUP_NAME \
    --name vm-onprem \
    --query "[0].virtualMachine.network.privateIpAddresses[0]" -o tsv)
echo "Private IP: $ONPREM_VM_PRIVATE_IP"

ONPREM_VM_PUBLIC_IP=$(az network public-ip show \
    --resource-group $RESOURCE_GROUP_NAME \
    --name pip-vm-onprem \
    --query ipAddress -o tsv)
echo "ssh $VM_ADMIN_USERNAME@$ONPREM_VM_PUBLIC_IP"
echo

echo "Spoke VM 資訊"
SPOKE_VM_PRIVATE_IP=$(az vm list-ip-addresses \
    --resource-group $RESOURCE_GROUP_NAME \
    --name vm-spoke \
    --query "[0].virtualMachine.network.privateIpAddresses[0]" -o tsv)
echo "Private IP: $SPOKE_VM_PRIVATE_IP"

SPOKE_VM_PUBLIC_IP=$(az network public-ip show \
    --resource-group $RESOURCE_GROUP_NAME \
    --name pip-vm-spoke \
    --query ipAddress -o tsv)
echo "ssh $VM_ADMIN_USERNAME@$SPOKE_VM_PUBLIC_IP"
echo

echo "Firewall 資訊"
AZFW_PRIVATE_IP="$(az network firewall ip-config list -g $RESOURCE_GROUP_NAME -f azfw-hub --query "[?name=='FW-config'].privateIpAddress" --output tsv)"
echo "Azure Firewall Private IP: $AZFW_PRIVATE_IP"

echo
echo "Password for $VM_ADMIN_USERNAME"
echo $VM_ADMIN_PASSWORD
echo