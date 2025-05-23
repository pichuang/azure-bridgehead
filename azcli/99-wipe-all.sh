#!/bin/bash

# Load .env
set -o allexport
source .env
set +o allexport

# Delete the resource group and all its contents
az group delete --name "$RESOURCE_GROUP_NAME" --yes --no-wait