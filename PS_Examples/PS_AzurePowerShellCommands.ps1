# Run the following command first in the console to bypass not digitally signed error
# Ref: http://tritoneco.com/2014/02/21/fix-for-powershell-script-not-digitally-signed/
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass


# Enter Azure credentials and then connect to your Azure subscription
# NOTE: Login form is in background (bug) Ref: https://github.com/Azure/azure-powershell/issues/8476
#Connect-AzAccount
# Show list of subscriptions
#az account list
# Set the subscription
#az account set --subscription "The-Subscription-Id"
# Show current subscription
#az account show
# Get a list of all Azure Locations and filter the JSON result for a paged list of alphabetically sorted location names 
#(az account list-locations | ConvertFrom-Json) | Select-Object name | Sort-Object -Property name | more


# Show PowerShell version detail
#$PSVersionTable.PSVersion


# To install Azure PowerShell, run the following command in an elevated session ("Run as Administrator" on Windows)
# Ref: https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-1.5.0
#Install-Module -Name Az -AllowClobber


# Show installed Azure PowerShell
#Get-InstalledModule -Name Az -AllVersions | Select-Object Name,Version


# List available modules
#Get-Module -ListAvailable


# Get a list of all Resource Groups as a table
#Get-AzResourceGroup | Format-Table


########## Popular PowerShell Commands ##########


# Get build information for Windows
#$(gin).WindowsBuildLabEx


# Set preview for PowerShell files
#Set-ItemProperty Registry::HKEY_CLASSES_ROOT\.ps1 -Name PerceivedType -Value text


# Set preview for Sheerpower source files
#Set-ItemProperty Registry::HKEY_CLASSES_ROOT\.spsrc -Name PerceivedType -Value text


# Get-PSDrive cmdlet gets the drives in the current session
#Get-PSDrive
