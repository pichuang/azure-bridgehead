# Azure Repair Man

> Code 999

## Description

1. 
2. 
3.

## Parameter

- Default Subscription: `repair`
- Default Region: `Brazil South`
- Default Code ID: `999`
- Default Network Address: `10.99.98.0/23`

- Parameter
  - Resource Group: `rg-repairman-repair-999`
  - VNet Name: `vnet-repair-brazil-south-999`
  - [Azure Subnet Design][2]:
    - `AzureFirewallSubnet` (/26 is minimal) : 10.99.98.0/26
    - `AzureFirewallManagementSubnet` (/26 is minimal) : 10.99.98.64/26
    - `RouteServerSubnet` (/27 is minimal): 10.99.98.128/27
    - `GatewaySubnet` (/29 is minimal, /27 is best): 10.99.98.160/27
    - `AzureBastionSubnet` (/27 is minimal, /26 is best): 10.99.98.192/26
    - `vnet-repair-brazil-south-999` (/24): 10.99.99.0/24

## Includes Linux Packages

```bash
mtr
deadman
tshark
ansible
docker
kubectl
kubectl krew
```

## Includes Windows Packages

```bash
WinMTR
```

## TODO

- Phase: Hackathaon - based on Azure script
  - [ ] Architect Design
  - [ ] Create a fixed resource group
  - [ ] Create a fixed VNet
  - [ ] Create those predefined subnets
  - [ ] Create a Linux VM (Based on Ubuntu 20.04 Minimal LTS)in `vnet-repair-brazil-south-999`
    - [ ] Pre-install Linux toolbox
    - [ ] Post-upgrade Linux toolbox based on ansible-playbook
  - [ ] Create a Windows VM (Based on [smalldisk] Windows Server 2022 Datacenter: Azure Edition Core
) in `vnet-repair-brazil-south-999`
    - [ ] Pre-install Windows packages
    - [ ] Post-upgrade Windows packages based on ansible-playbook

## References

- [Azure Resource Naming][1]

## Project Sponsorship

![Hackathon Logo](/images/about-hackathon-logo.png)

[1]: https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming
[2]: https://www.davidc.net/sites/default/subnets/subnets.html?network=10.99.98.0&mask=23&division=11.760