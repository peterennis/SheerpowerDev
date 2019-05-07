# This script creates an Azure Virtual Machine running Windows Server 2016.
# After running the script, you can access the virtual machine through a Remote Desktop connection.
# This example works in PowerShell 5.1+
# Ref: https://docs.microsoft.com/en-us/azure/virtual-machines/scripts/virtual-machines-windows-cli-sample-create-vm-quick-create?toc=%2fazure%2fvirtual-machines%2fwindows%2ftoc.json

# Update the admin password!!!
$AdminPassword="ChangeYourAdminPassword1"

$myLocation = "westus"
$myResourceGroup = "myTestResourceGroup"
$myVM = "myVM"
$azureUser = "azureuser"

# Create a resource group in a location.
az group create --name $myResourceGroup --location $myLocation

# Create a virtual machine in the resource group.
az vm create `
    --resource-group $myResourceGroup `
    --name $myVM `
    --image win2016datacenter `
    --admin-username $azureuser `
    --admin-password $AdminPassword `
    --verbose
##    --no-wait `


# Clean up deployment
# Run the following command to remove the resource group, VM, and all related resources.
# az group delete --name myResourceGroup --yes --verbose

