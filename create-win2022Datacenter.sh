#!/bin/bash
set -x

#
# Ref: https://blog.miniasp.com/post/2022/07/04/How-to-create-VM-using-Azure-CLI
#

#
# Spec
# Win2022Datacenter
# Standard_D2s_v3
#

##############################
##### START - VARIABLES ######
##############################

SUBSCRIPTION_NAME="airs-for-pinhuang"
LOCATION="eastus"
RESOURCEGROUP="rg-lab"
VNET_NAME="vnet-lab-eastus"
VM_SUBNET_NAME="subnet-lab-eastus"
VM_NAME="vm-aro-win"
USERNAME="repairman"
PASSWORD="Lyc0r!sRec0il"


##############################
##### END - VARIABLES ######
##############################

##############################
####### START - SCRIPT #######
##############################

az group create --name $RESOURCEGROUP \
  --location $LOCATION

#
# Create Win2022AzureEditionCore VM
#
# 1m49.653s
#
time az vm create \
  --resource-group $RESOURCEGROUP \
  --name $VM_NAME \
  --location $LOCATION \
  --size Standard_D2s_v3 \
  --image Win2022Datacenter \
  --admin-username $USERNAME \
  --admin-password $PASSWORD \
  --storage-sku os=StandardSSD_LRS \
  --vnet-name $VNET_NAME \
  --subnet $VM_SUBNET_NAME \
  --nic-delete-option delete \
  --os-disk-delete-option delete \
  --public-ip-address pip-$VM_NAME \
  --public-ip-sku Standard \
  --public-ip-address-allocation 'static'

#
# Set RDP Port
#
# 1m33.356s
#
time az vm run-command invoke \
  --resource-group $RESOURCEGROUP \
  --name $VM_NAME \
  --command-id SetRDPPort \
  --parameters '{"RDPPort":3389}'

#
# Install WSL2
# Ref: https://docs.microsoft.com/zh-tw/azure/virtual-machines/windows/run-command
#
# 1m2.851s
#

az vm run-command invoke \
  --resource-group $RESOURCEGROUP \
  --name $VM_NAME \
  --command-id RunPowerShellScript \
  --scripts "wsl --install -d Ubuntu-20.04"

sleep 30

#
# System reboot for WSL2 installed
#
az vm restart \
  --resource-group $RESOURCEGROUP \
  --name $VM_NAME


# TODO: Ansible for Day 2 Operations

#
# Change Font Size
#
# az vm run-command invoke \
#   --resource-group $RESOURCEGROUP \
#   --name $VM_NAME \
#   --command-id RunPowerShellScript \
#   --scripts "Import-Module SetConsoleFont; Set-ConsoleFont -Name 'Consolas' -Size 20"

#
# Install Linux Packages into WSL2 for Ubuntu 20.04
#
# az vm run-command invoke --resource-group rg-lab --name vm-aro-win --command-id RunPowerShellScript --scripts 'wsl -- apt update -y; wsl -- apt upgrade -y; wsl -- apt install -y git vim mtr; wsl -- apt autoremove -y'
#
# az vm run-command invoke \
#   --resource-group $RESOURCEGROUP \
#   --name $VM_NAME \
#   --command-id RunPowerShellScript \
#   --scripts "wsl -- apt update -y; wsl -- apt upgrade -y; wsl -- apt install -y git vim mtr; wsl -- apt autoremove -y"

#
# Obtain Public IP
#
az vm show \
  --resource-group $RESOURCEGROUP \
  --name $VM_NAME \
  --show-details \
  --query publicIps \
  -o tsv
