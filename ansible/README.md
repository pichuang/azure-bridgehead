# Project Repairman using Ansible

## Workaround for WSL2

```bash
chmod o-w .
```

## Playbook

### `$ ANSIBLE_CONFIG=./ansible.cfg ansible-playbook deploy-repairman.yml`
```bash
******************************************************************************************************************
localhost                  : ok=4    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

Friday 16 September 2022  00:05:19 +0800 (0:02:04.838)       0:02:27.327 ******
===============================================================================
Create windows VM -------------------------------------------------------------------------------------------------------------------- 124.84s 
Create VNET --------------------------------------------------------------------------------------------------------------------------- 10.28s 
Create Subnet -------------------------------------------------------------------------------------------------------------------------- 7.13s 
Create Resource Group ------------------------------------------------------------------------------------------------------------------ 4.99s 
```


## Reference

- [Azure VM Image List](https://az-vm-image.info/)
- [Ansible Azure Modules](https://docs.ansible.com/ansible/latest/modules/list_of_cloud_modules.html#azure)
- [Create a Windows 10 Virtual Machine on Azure With Ansible](https://www.ntweekly.com/2021/05/23/create-a-windows-10-virtual-machine-on-azure-with-ansible/)
