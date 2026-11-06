#!/usr/bin/env bash
# Delete every resource created for the assignment (VM, disk, network, public IP,
# storage account). Run in Azure Cloud Shell once the report has been submitted.
set -euo pipefail

RG="WaseemIsaac-RG"
read -r -p "Delete resource group '$RG' and EVERYTHING in it? (yes/no) " answer
if [ "$answer" = "yes" ]; then
  az group delete --name "$RG" --yes --no-wait
  echo "Deletion started."
else
  echo "Cancelled."
fi
