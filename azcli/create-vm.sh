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
LOCATION="japaneast"
RESOURCEGROUP="rg-devopsday"
VNET_NAME="vnet-zz-cluster"
VNET_CIDR="10.10.10.0/24"
REPAIRMAN_CIDR="10.10.10.64/27"
REPAIRMAN_SUBNET_NAME="subnet-lab-japanwest"
VM_NAME="vm-zz-win"
USERNAME="repairman"
PASSWORD="Lyc0r!sRec0il"


##############################
##### END - VARIABLES ######
##############################

##############################
####### START - SCRIPT #######
##############################

# az group create --name $RESOURCEGROUP \
#   --location $LOCATION

az network vnet create \
  --resource-group $RESOURCEGROUP \
  --name $VNET_NAME \
  --address-prefixes $VNET_CIDR

az network vnet subnet create \
  --resource-group $RESOURCEGROUP \
  --vnet-name $VNET_NAME \
  --name $REPAIRMAN_SUBNET_NAME \
  --address-prefixes $REPAIRMAN_CIDR \
  --service-endpoints Microsoft.ContainerRegistry

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
  --subnet $REPAIRMAN_SUBNET_NAME \
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

# XXX: This command will fail, but it's ok.

az vm run-command invoke \
  --resource-group $RESOURCEGROUP \
  --name $VM_NAME \
  --command-id RunPowerShellScript \
  --scripts "wsl --install -d Ubuntu-20.04"




# Install the OpenSSH Server
az vm run-command invoke \
  --resource-group $RESOURCEGROUP \
  --name $VM_NAME \
  --command-id RunPowerShellScript \
  --scripts "Add-WindowsCapability -Online -Name OpenSSH.Server~~~~"


# Start the OpenSSH Server
az vm run-command invoke \
  --resource-group $RESOURCEGROUP \
  --name $VM_NAME \
  --command-id RunPowerShellScript \
  --scripts "Start-Service sshd  -StartupType 'Automatic'"

# Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
az vm run-command invoke \
  --resource-group $RESOURCEGROUP \
  --name $VM_NAME \
  --command-id RunPowerShellScript \
  --scripts "Get-NetFirewallRule -DisplayName 'OpenSSH Server (sshd)'"



sleep 30

#
# System reboot for WSL2 installed
#
az vm restart \
  --resource-group $RESOURCEGROUP \
  --name $VM_NAME

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
# Enable ICMP v4 and v6
#
az vm run-command invoke \
  --resource-group $RESOURCEGROUP \
  --name $VM_NAME \
  --command-id RunPowerShellScript \
  --scripts "netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol="icmpv4:8,any" dir=in action=allow"

az vm run-command invoke \
  --resource-group $RESOURCEGROUP \
  --name $VM_NAME \
  --command-id RunPowerShellScript \
  --scripts "netsh advfirewall firewall add rule name="ICMP Allow incoming V6 echo request" protocol="icmpv6:8,any" dir=in action=allow"

#
# Obtain Public IP
#
az vm show \
  --resource-group $RESOURCEGROUP \
  --name $VM_NAME \
  --show-details \
  --query publicIps \
  -o tsv
