# Azure Bridgehead

> Code 999

## Parameter

- Default Subscription: `bridgehead`
- Default Region: `East US`
- Default Code ID: `999`
- Default Network Address: `10.99.98.0/23`

- Parameter
  - Resource Group: `rg-briagehead-999`
  - VNet Name: `vnet-briagehead`
  - [Azure Subnet Design][2]:
    - `AzureFirewallSubnet` (/26 is minimal) : 10.99.98.0/26
    - `AzureFirewallManagementSubnet` (/26 is minimal) : 10.99.98.64/26
    - `RouteServerSubnet` (/27 is minimal): 10.99.98.128/27
    - `GatewaySubnet` (/29 is minimal, /27 is best): 10.99.98.160/27
    - `AzureBastionSubnet` (/26 is best): 10.99.98.192/26
    - `subnet-hub` (/24): 10.99.99.0/24
  - VM
    - 10.99.99.4
    - repairman / Lyc0r!sRec0il

More info in [Visual Subnet Calculator (Azure Edition)][3]

## How to use?

``` bash
terraform init
terraform plan
terraform apply -auto-approve
```

```bash
terraform destroy -auto-approve
```

## References

- [Azure Resource Naming][1]


[1]: https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming
[2]: https://www.davidc.net/sites/default/subnets/subnets.html?network=10.99.98.0&mask=23&division=11.760
[3]: https://blog.pichuang.com.tw/azure-subnets.html