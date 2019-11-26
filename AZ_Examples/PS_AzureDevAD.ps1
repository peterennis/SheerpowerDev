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
<#
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
#>

# Create DC1 VM and configure it as the DC for testlab.<your public domain> AD DS domain and a DNS server for the VMs of TestLab virtual network.
# You will be prompted for username/password for the local administrator account on DC1. Use a strong password and username/password securely.
<#
$rgName="<resource group name>"
$locName=(Get-AzResourceGroup -Name $rgName).Location
$vnet=Get-AzVirtualNetwork -Name TestLab -ResourceGroupName $rgName
$pip=New-AzPublicIpAddress -Name DC1-PIP -ResourceGroupName $rgName -Location $locName -AllocationMethod Dynamic
$nic=New-AzNetworkInterface -Name DC1-NIC -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -PrivateIpAddress 10.0.0.4
$vm=New-AzVMConfig -VMName DC1 -VMSize Standard_B2s
$cred=Get-Credential -Message "Type the name and password of the local administrator account for DC1."
$vm=Set-AzVMOperatingSystem -VM $vm -Windows -ComputerName DC1 -Credential $cred -ProvisionVMAgent -EnableAutoUpdate
$vm=Set-AzVMSourceImage -VM $vm -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2019-Datacenter -Version "latest"
$vm=Add-AzVMNetworkInterface -VM $vm -Id $nic.Id
$vm=Set-AzVMOSDisk -VM $vm -Name "DC1-OS" -DiskSizeInGB 128 -CreateOption FromImage
$diskConfig=New-AzDiskConfig -AccountType "Standard_LRS" -Location $locName -CreateOption Empty -DiskSizeGB 20
$dataDisk1=New-AzDisk -DiskName "DC1-DataDisk1" -Disk $diskConfig -ResourceGroupName $rgName
$vm=Add-AzVMDataDisk -VM $vm -Name "DC1-DataDisk1" -CreateOption Attach -ManagedDiskId $dataDisk1.Id -Lun 1
New-AzVM -ResourceGroupName $rgName -Location $locName -VM $vm
#>

<# Successful Output
RequestId IsSuccessStatusCode StatusCode ReasonPhrase
--------- ------------------- ---------- ------------
                         True         OK OK
#>

<#
Next, connect to the DC1 virtual machine.
In the Azure portal, click Resource Groups > [resource group name] > DC1 > Connect.
In the open pane, click Download RDP file. Open the DC1.rdp file that is downloaded, and then click Connect.
Specify the DC1 local administrator account name:
Windows 10:
In the Windows Security dialog box, click More choices, and then click Use a different account. In User name, type DC1\[Local administrator account name].
In Password, type the password of the local administrator account, and then click OK.
When prompted, click Yes.
#>

