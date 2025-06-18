#!/bin/bash

# ==============================================
# Azure Infrastructure Provisioning Script
# Author: Aditya Saxena
# Description: Creates a resource group and VNet
# ==============================================

# --- Error handling setup ---
set -e          # Exit on error
set -o pipefail # Catch pipeline errors
trap 'echo "⚠️ Error occurred on line $LINENO. Exiting..."; exit 1' ERR

# --- Logging setup ---
LOG_FILE="deployment.log"
exec > >(tee -a "$LOG_FILE") 2>&1
echo "=== Deployment started at $(date) ==="

# --- Environment variables ---
RESOURCE_GROUP="myRG"
LOCATION="eastus"
VNET_NAME="myVNet"
ADDRESS_PREFIX="10.0.0.0/16"
SUBNET_NAME="mySubnet"
SUBNET_PREFIX="10.0.1.0/24"

# --- Check Azure login ---
echo "🔐 Checking Azure login..."
az account show &>/dev/null || az login

# --- Create Resource Group ---
echo "📁 Creating resource group..."
az group create --name "$RESOURCE_GROUP" --location "$LOCATION"

# --- Create Virtual Network ---
echo "🌐 Creating virtual network..."
az network vnet create \
  --name "$VNET_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --address-prefix "$ADDRESS_PREFIX" \
  --subnet-name "$SUBNET_NAME" \
  --subnet-prefix "$SUBNET_PREFIX"

echo "✅ Provisioning complete at $(date)"
