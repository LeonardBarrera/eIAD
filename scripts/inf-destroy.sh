#!/bin/bash
set -e

# Get the directory that this script is in
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# load env vars
source "${DIR}/load-env.sh"

figlet Infrastructure DESTROY

if [ -n "${TF_IN_AUTOMATION}" ]
then
    echo "Delete the resource group $TF_VAR_resource_group_name, but don't wait (fire and forget)"

    az login --service-principal -u "$ARM_CLIENT_ID" -p "$ARM_CLIENT_SECRET" --tenant "$ARM_TENANT_ID"
    az account set -s "$ARM_SUBSCRIPTION_ID"
    az group delete \
        --resource-group $TF_VAR_resource_group_name \
        --yes \
        --no-wait

    echo "Resource group will be deleted."
else
    echo "ERROR: inf-destroy.sh does not run outside of build automation"
    echo "Use the following command to do this manually:"
    echo
    echo az group delete --resource-group $TF_VAR_resource_group_name --yes --no-wait
    echo
fi


