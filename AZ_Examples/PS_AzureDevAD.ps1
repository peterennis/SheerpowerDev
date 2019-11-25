# Run the following command first in the console to bypass not digitally signed error
# Ref: http://tritoneco.com/2014/02/21/fix-for-powershell-script-not-digitally-signed/
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Ref: https://docs.microsoft.com/en-us/microsoft-365/enterprise/simulated-ent-base-configuration-microsoft-365-enterprise

# Sign in to your Azure account with the following command
#Connect-AzAccount

# Get your subscription name using the following command.
#Get-AzSubscription | Sort-Object Name | Select-Object Name

# Set your Azure subscription. Replace everything within the quotes, including the < and > characters, with the correct name.
#$subscr="<subscription name>"
#Get-AzSubscription -SubscriptionName $subscr | Select-AzSubscription

# Create a new resource group for the enterprise test lab. To determine a unique resource group name, use this command to list your existing resource groups.
#Get-AzResourceGroup | Sort-Object ResourceGroupName | Select-Object ResourceGroupName

# Create a new resource group with these commands. Replace everything within the quotes, including the < and > characters, with the correct names.
#$rgName = "<resource group name>"
#$locName = "<location name, such as West US>"
#New-AzResourceGroup -Name $rgName -Location $locName

# Create a virtual network to host a subnet of the lab enterprise environment and protect it with a network security group.
Clear-Host      # Workaround for buffer overflow on console, Ref: https://github.com/PowerShell/vscode-powershell/issues/1536
$rgName = "<name of your new resource group>"
$locName = (Get-AzResourceGroup -Name $rgName).Location
$corpnetSubnet = New-AzVirtualNetworkSubnetConfig -Name Corpnet -AddressPrefix 10.0.0.0/24
New-AzVirtualNetwork -Name TestLab -ResourceGroupName $rgName -Location $locName -AddressPrefix 10.0.0.0/8 -Subnet $corpnetSubnet -DNSServer 10.0.0.4
$rule1 = New-AzNetworkSecurityRuleConfig -Name "RDPTraffic" -Description "Allow RDP to all VMs on the subnet" -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389
New-AzNetworkSecurityGroup -Name Corpnet -ResourceGroupName $rgName -Location $locName -SecurityRules $rule1
$vnet = Get-AzVirtualNetwork -ResourceGroupName $rgName -Name TestLab
$nsg = Get-AzNetworkSecurityGroup -Name Corpnet -ResourceGroupName $rgName
Set-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name Corpnet -AddressPrefix "10.0.0.0/24" -NetworkSecurityGroup $nsg
$vnet | Set-AzVirtualNetwork

