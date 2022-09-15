#!/bin/bash


# Ref
# https://docs.ansible.com/ansible/2.9/installation_guide/intro_installation.html#installing-ansible-on-ubuntu
#

sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
ansible --version
ansible-galaxy --version

# Ref
# https://galaxy.ansible.com/azure/azcollection
#

# Install Ansible az collection for interacting with Azure.
ansible-galaxy collection install azure.azcollection --force

# Install Ansible modules for Azure
pip3 install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt --force
