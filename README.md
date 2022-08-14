# Azure Repair Man

Default Subscription: `repair`
Default Region: `Brazil South`
Default Insntace ID: `999`
Default Network Address: 10.99.98.0/23

- Content
  - Resource Group: `rg-repairman-repair-999` #rg-<app or service name>-<subscription type>-<###> 
  - VNet Name: `vnet-repair-brazil-south-999`  #vnet-<subscription type>-<region>-<###>
  - Subnet Name: #snet-<subscription>-<region>-<###>
    - `AzureFirewallSubnet` (/26 is minimal) : 10.99.98.0/26
    - `AzureFirewallManagementSubnet` (/26 is minimal) : 10.99.98.64/26
    - `GatewaySubnet ` (/29 is minimal, 27 is best): 10.99.98.160/27
    - `AzureBastionSubnet` (/27 is minimal, /26 is best): 10.99.98.192/26
    - `snet-repair-brazil-south-999` (/24): 10.99.99.0/24


## References
- [Azure Resource Naming][1]

[1]: https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming