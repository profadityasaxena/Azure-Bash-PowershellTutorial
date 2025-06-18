<#
.SYNOPSIS
    Provision basic Azure resources using Az module in PowerShell.

.DESCRIPTION
    - Checks Az module availability and logs in interactively
    - Creates a resource group and storage account
    - Adds tags and applies basic RBAC
    - Logs output and handles errors
#>

# ===============================
# Initialization and Parameters
# ===============================

$resourceGroup = "RG-PowerShell"
$location = "eastus"
$storageAccount = "pshellstorage$(Get-Random -Maximum 9999)"
$logFile = "AzureProvisionLog.txt"

# Enable logging
Start-Transcript -Path $logFile -Append

# ===============================
# Az Module and Login
# ===============================

if (-not (Get-Module -ListAvailable -Name Az)) {
    Install-Module -Name Az -Scope CurrentUser -Force
}

Import-Module Az
Connect-AzAccount

# ===============================
# Try/Catch for Robust Handling
# ===============================

try {
    Write-Host "Creating resource group..." -ForegroundColor Cyan
    New-AzResourceGroup -Name $resourceGroup -Location $location -ErrorAction Stop

    Write-Host "Creating storage account..." -ForegroundColor Cyan
    New-AzStorageAccount -ResourceGroupName $resourceGroup `
                         -Name $storageAccount `
                         -Location $location `
                         -SkuName Standard_LRS `
                         -Kind StorageV2 `
                         -EnableHttpsTrafficOnly $true `
                         -Tag @{ Project="Demo"; Owner="Aditya" } `
                         -ErrorAction Stop

    Write-Host "Assigning reader role to current user..." -ForegroundColor Cyan
    $user = (Get-AzContext).Account.Id
    New-AzRoleAssignment -ObjectId $user -RoleDefinitionName "Reader" -Scope "/subscriptions/$(Get-AzContext).Subscription.Id/resourceGroups/$resourceGroup"

    Write-Host "✅ All resources created successfully."

} catch {
    Write-Error "❌ An error occurred: $_"
} finally {
    Stop-Transcript
}

# ===============================
# End of Script
# ===============================
