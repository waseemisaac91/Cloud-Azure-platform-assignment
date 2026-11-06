#!/usr/bin/env bash
# Create the resource group and the Ubuntu VM used in the assignment.
# Run in Azure Cloud Shell (Bash). Requires an active Azure subscription.
set -euo pipefail

RG="WaseemIsaac-RG"
VM="WaseemIsaac-VM"
LOCATION="swedencentral"

# Resource group (created in West Europe; its region only stores metadata)
az group create --name "$RG" --location westeurope

# Ubuntu Server 22.04 LTS from Canonical (official image: no paid Marketplace offer)
az vm create \
  --resource-group "$RG" \
  --name "$VM" \
  --location "$LOCATION" \
  --image Canonical:0001-com-ubuntu-server-jammy:22_04-lts-gen2:latest \
  --size Standard_B2ats_v2 \
  --storage-sku StandardSSD_LRS \
  --admin-username azureuser \
  --generate-ssh-keys \
  --public-ip-sku Standard \
  --nsg-rule SSH
# Optional tags: add  --tags Student=WaseemIsaac Purpose=Assignment

# Allow HTTP so the Apache web site is reachable from outside
az vm open-port --resource-group "$RG" --name "$VM" --port 80 --priority 1010
