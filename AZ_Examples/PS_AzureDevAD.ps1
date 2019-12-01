# Run the following command first in the console to bypass not digitally signed error
# Ref: http://tritoneco.com/2014/02/21/fix-for-powershell-script-not-digitally-signed/
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass


<#------------------------------------------------------------------ 
# VARIABLES USED
# $TheServerSku = "2019-Datacenter"
# $TheVMSku = "Standard_B2s"
# -StorageAccountName $stDiagName Ref: https://techcommunity.microsoft.com/t5/Azure/WARNING-Since-the-VM-is-created-using-premium-storage-existing/m-p/133863
$subscr="<subscription name>"
$rgName = "<resource group name>"
$locName = "<location name, such as West US>"
$corpnetSubnet
$rule1
$vnet
$nsg
$pip
$nic
$vm
$cred
$diskConfig
$dataDisk1
$yourDomain="<your public domain>"
User1/Password
-------------------------------------------------------------------#>


# Ref: https://docs.microsoft.com/en-us/microsoft-365/enterprise/simulated-ent-base-configuration-microsoft-365-enterprise

# Method 2: Build your simulated intranet with Azure PowerShell
# =============================================================

# Step 1: Create DC1
# ==================

# Sign in to your Azure account with the following command
<#
Connect-AzAccount
#>

# Get your subscription name using the following command.
<#
Get-AzSubscription | Sort-Object Name | Select-Object Name
#>

# Set your Azure subscription. Replace everything within the quotes, including the < and > characters, with the correct name.
<#
$subscr = "<subscription name>"
Get-AzSubscription -SubscriptionName $subscr | Select-AzSubscription
#>

# Create a new resource group for the enterprise test lab. To determine a unique resource group name, use this command to list your existing resource groups.
<#
Get-AzResourceGroup | Sort-Object ResourceGroupName | Select-Object ResourceGroupName
#>

# Create a new resource group with these commands. Replace everything within the quotes, including the < and > characters, with the correct names.
<#
$rgName = "<resource group name>"
$locName = "<location name, such as West US>"
New-AzResourceGroup -Name $rgName -Location $locName
#>

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
$rgName = "<resource group name>"
$locName = (Get-AzResourceGroup -Name $rgName).Location
$vnet = Get-AzVirtualNetwork -Name TestLab -ResourceGroupName $rgName
$pip = New-AzPublicIpAddress -Name DC1-PIP -ResourceGroupName $rgName -Location $locName -AllocationMethod Dynamic
$nic = New-AzNetworkInterface -Name DC1-NIC -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -PrivateIpAddress 10.0.0.4
$vm = New-AzVMConfig -VMName DC1 -VMSize Standard_B2s
$cred = Get-Credential -Message "Type the name and password of the local administrator account for DC1."
$vm = Set-AzVMOperatingSystem -VM $vm -Windows -ComputerName DC1 -Credential $cred -ProvisionVMAgent -EnableAutoUpdate
$vm = Set-AzVMSourceImage -VM $vm -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2019-Datacenter -Version "latest"
$vm = Add-AzVMNetworkInterface -VM $vm -Id $nic.Id
$vm = Set-AzVMOSDisk -VM $vm -Name "DC1-OS" -DiskSizeInGB 128 -CreateOption FromImage
$diskConfig = New-AzDiskConfig -AccountType "Standard_LRS" -Location $locName -CreateOption Empty -DiskSizeGB 20
$dataDisk1 = New-AzDisk -DiskName "DC1-DataDisk1" -Disk $diskConfig -ResourceGroupName $rgName
$vm = Add-AzVMDataDisk -VM $vm -Name "DC1-DataDisk1" -CreateOption Attach -ManagedDiskId $dataDisk1.Id -Lun 1
New-AzVM -ResourceGroupName $rgName -Location $locName -VM $vm
#>

<#------------------------------------------------------------------ 
# Successful Output
RequestId IsSuccessStatusCode StatusCode ReasonPhrase
--------- ------------------- ---------- ------------
                         True         OK OK
-------------------------------------------------------------------#>

<#------------------------------------------------------------------
Next, connect to the DC1 virtual machine.
In the Azure portal, click Resource Groups > [resource group name] > DC1 > Connect.
In the open pane, click Download RDP file. Open the DC1.rdp file that is downloaded, and then click Connect.
Specify the DC1 local administrator account name:
Windows 10:
In the Windows Security dialog box, click More choices, and then click Use a different account. In User name, type DC1\[Local administrator account name].
In Password, type the password of the local administrator account, and then click OK.
When prompted, click Yes.
-------------------------------------------------------------------#>

# Next, add an extra data disk as a new volume with the drive letter F: with this command at an administrator-level Windows PowerShell command prompt on DC1.
<#
Get-Disk | Where-Object PartitionStyle -eq "RAW" | Initialize-Disk -PartitionStyle MBR -PassThru | New-Partition -AssignDriveLetter -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel "WSAD Data"
#>

<#------------------------------------------------------------------
# Sample Command/Output from an administrator-level Windows PowerShell command prompt on DC1:
```
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\Users\peterennis> Get-Disk | Where-Object PartitionStyle -eq "RAW" | Initialize-Disk -PartitionStyle MBR -PassThru | New-
Partition -AssignDriveLetter -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel "WSAD Data"

DriveLetter FriendlyName FileSystemType DriveType HealthStatus OperationalStatus SizeRemaining  Size
----------- ------------ -------------- --------- ------------ ----------------- -------------  ----
F           WSAD Data    NTFS           Fixed     Healthy      OK                     19.94 GB 20 GB


PS C:\Users\peterennis>
```
-------------------------------------------------------------------#>

# Next, configure DC1 as a domain controller and DNS server for the testlab.<your public domain> domain.
# Specify your public domain name, remove the < and > characters, and then run these commands at
# an administrator-level Windows PowerShell command prompt on DC1.
<#
$yourDomain = "<your public domain>"
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName testlab.$yourDomain -DatabasePath "F:\NTDS" -SysvolPath "F:\SYSVOL" -LogPath "F:\Logs"
#>

<#------------------------------------------------------------------
You will need to specify a safe mode administrator password. Store this password in a secure location.
Note that these commands can take a few minutes to complete.

```
PS C:\Users\peterennis> Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Success Restart Needed Exit Code      Feature Result
------- -------------- ---------      --------------
True    No             Success        {Active Directory Domain Services, Group P...
```

SafeModeAdministratorPassword: ************
Confirm SafeModeAdministratorPassword: ************

The target server will be configured as a domain controller and restarted when this operation is complete.
Do you want to continue with this operation?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"):
WARNING: Windows Server 2019 domain controllers have a default for the security setting named "Allow cryptography
algorithms compatible with Windows NT 4.0" that prevents weaker cryptography algorithms when establishing security
channel sessions.

For more information about this setting, see Knowledge Base article 942564
(http://go.microsoft.com/fwlink/?LinkId=104751).

WARNING: This computer has at least one physical network adapter that does not have static IP address(es) assigned to
its IP Properties. If both IPv4 and IPv6 are enabled for a network adapter, both IPv4 and IPv6 static IP addresses
should be assigned to both IPv4 and IPv6 Properties of the physical network adapter. Such static IP address(es)
assignment should be done to all the physical network adapters for reliable Domain Name System (DNS) operation.

WARNING: A delegation for this DNS server cannot be created because the authoritative parent zone cannot be found or it
 does not run Windows DNS server. If you are integrating with an existing DNS infrastructure, you should manually
create a delegation to this DNS server in the parent zone to ensure reliable name resolution from outside the domain
"testlab.adaept.com". Otherwise, no action is required.

WARNING: Windows Server 2019 domain controllers have a default for the security setting named "Allow cryptography
algorithms compatible with Windows NT 4.0" that prevents weaker cryptography algorithms when establishing security
channel sessions.

For more information about this setting, see Knowledge Base article 942564
(http://go.microsoft.com/fwlink/?LinkId=104751).

etc. some more warning messages about WS 2019 configuration...
-------------------------------------------------------------------#>

<#------------------------------------------------------------------
After DC1 restarts, reconnect to the DC1 virtual machine.

In the Azure portal, click Resource Groups > [your resource group name] > DC1 > Connect.
Run the DC1.rdp file that is downloaded, and then click Connect.
In Windows Security, click Use another account. In User name, type TESTLAB\[Local administrator account name].
In Password, type the password of the local administrator account, and then click OK.
When prompted, click Yes.
-------------------------------------------------------------------#>

# Next, create a user account in Active Directory that will be used when logging in to TESTLAB domain member computers.
# Run this command at an administrator-level Windows PowerShell command prompt.
<#
New-ADUser -SamAccountName User1 -AccountPassword (read-host "Set user password" -assecurestring) -name "User1" -enabled $true -PasswordNeverExpires $true -ChangePasswordAtLogon $false
#>

# Note that this command prompts you to supply the User1 account password.
# Because this account will be used for remote desktop connections for all TESTLAB domain member computers,
# choose a strong password. Record the User1 account password and store it in a secured location.

# Next, configure the new User1 account as a domain, enterprise, and schema administrator.
# Run this command at the administrator-level Windows PowerShell command prompt.
<#
$yourDomain = "<your public domain>"
$domainName = "testlab." + $yourDomain
$userName = "user1@" + $domainName
$userSID = (New-Object System.Security.Principal.NTAccount($userName)).Translate([System.Security.Principal.SecurityIdentifier]).Value
$groupNames = @("Domain Admins", "Enterprise Admins", "Schema Admins")
ForEach ($name in $groupNames) { Add-ADPrincipalGroupMembership -Identity $userSID -MemberOf (Get-ADGroup -Identity $name).SID.Value }
#>

# Close the Remote Desktop session with DC1 and then reconnect using the TESTLAB\User1 account.
# Next, to allow traffic for the Ping tool, run this command at an administrator-level Windows PowerShell command prompt.
<#
Set-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" -enabled True
#>

# Step 2: Configure APP1
# =====================

# In this step, you create and configure APP1, which is an application server that initially provides web and file sharing services.
# To create an Azure Virtual Machine for APP1, fill in the name of your resource group and run these commands
# at the command prompt on your local computer.

<#
$rgName = "<resource group name>"
$locName = (Get-AzResourceGroup -Name $rgName).Location
$vnet = Get-AzVirtualNetwork -Name TestLab -ResourceGroupName $rgName
$pip = New-AzPublicIpAddress -Name APP1-PIP -ResourceGroupName $rgName -Location $locName -AllocationMethod Dynamic
$nic = New-AzNetworkInterface -Name APP1-NIC -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id
$vm = New-AzVMConfig -VMName APP1 -VMSize Standard_B2s
$cred = Get-Credential -Message "Type the name and password of the local administrator account for APP1."
# pause to enter password
# New-AzVM : The supplied password must be between 8-123 characters long and must satisfy at least 3 of password complexity requirements from the following:
# 1) Contains an uppercase character
# 2) Contains a lowercase character
# 3) Contains a numeric digit
# 4) Contains a special character
# 5) Control characters are not allowed
$vm = Set-AzVMOperatingSystem -VM $vm -Windows -ComputerName APP1 -Credential $cred -ProvisionVMAgent -EnableAutoUpdate
$vm = Set-AzVMSourceImage -VM $vm -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2019-Datacenter -Version "latest"
$vm = Add-AzVMNetworkInterface -VM $vm -Id $nic.Id
$vm = Set-AzVMOSDisk -VM $vm -Name "APP1-OS" -DiskSizeInGB 128 -CreateOption FromImage
New-AzVM -ResourceGroupName $rgName -Location $locName -VM $vm
#>

<#------------------------------------------------------------------
```
RequestId IsSuccessStatusCode StatusCode ReasonPhrase
--------- ------------------- ---------- ------------
                         True         OK OK
```
-------------------------------------------------------------------#>

# Next, connect to the APP1 virtual machine using the APP1 local administrator account name and password,
# and then open a Windows PowerShell command prompt.
# To check name resolution and network communication between APP1 and DC1,
# run the ping dc1.testlab.<your public domain name> command and verify that there are four replies.

<#------------------------------------------------------------------
```
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\Users\peterennis> ping dc1.testlab.adaept.com

Pinging dc1.testlab.adaept.com [10.0.0.4] with 32 bytes of data:
Reply from 10.0.0.4: bytes=32 time<1ms TTL=128
Reply from 10.0.0.4: bytes=32 time<1ms TTL=128
Reply from 10.0.0.4: bytes=32 time=1ms TTL=128
Reply from 10.0.0.4: bytes=32 time=1ms TTL=128

Ping statistics for 10.0.0.4:
    Packets: Sent = 4, Received = 4, Lost = 0 (0% loss),
Approximate round trip times in milli-seconds:
    Minimum = 0ms, Maximum = 1ms, Average = 0ms
PS C:\Users\peterennis>
```
-------------------------------------------------------------------#>

# Next, join the APP1 virtual machine to the TESTLAB domain with these commands at the Windows PowerShell prompt.
# Note that you must supply the TESTLAB\User1 domain account credentials after running the Add-Computer command.
<#
$yourDomain = "<your public domain name>"
Add-Computer -DomainName ("testlab" + $yourDomain)
Restart-Computer
#>

# After APP1 restarts, connect to it using the TESTLAB\User1 account,
# and then open an administrator-level Windows PowerShell command prompt.
# Next, make APP1 a web server with this command at an administrator-level Windows PowerShell command prompt on APP1.
<#
Install-WindowsFeature Web-WebServer -IncludeManagementTools
#>

<#------------------------------------------------------------------
```
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\windows\system32> Install-WindowsFeature Web-WebServer -IncludeManagementTools

Success Restart Needed Exit Code      Feature Result
------- -------------- ---------      --------------
True    No             Success        {Common HTTP Features, Default Document, D...


PS C:\windows\system32>
```
-------------------------------------------------------------------#>

# Next, create a shared folder and a text file within the folder on APP1 with these PowerShell commands.
<#
New-Item -path c:\files -type directory
Write-Output "This is a shared file." | out-file c:\files\example.txt
New-SmbShare -name files -path c:\files -changeaccess TESTLAB\User1
#>

# Step 3: Configure CLIENT1
# =========================

# Create and configure CLIENT1, which acts as a typical laptop, tablet, or desktop computer on the intranet.
<#
$rgName = "<resource group name>"
$locName = (Get-AzResourceGroup -Name $rgName).Location
$vnet = Get-AzVirtualNetwork -Name TestLab -ResourceGroupName $rgName
$pip = New-AzPublicIpAddress -Name CLIENT1-PIP -ResourceGroupName $rgName -Location $locName -AllocationMethod Dynamic
$nic = New-AzNetworkInterface -Name CLIENT1-NIC -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id
$vm = New-AzVMConfig -VMName CLIENT1 -VMSize Standard_B2s
$cred = Get-Credential -Message "Type the name and password of the local administrator account for CLIENT1."
$vm = Set-AzVMOperatingSystem -VM $vm -Windows -ComputerName CLIENT1 -Credential $cred -ProvisionVMAgent -EnableAutoUpdate
$vm = Set-AzVMSourceImage -VM $vm -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2019-Datacenter -Version "latest"
$vm = Add-AzVMNetworkInterface -VM $vm -Id $nic.Id
$vm = Set-AzVMOSDisk -VM $vm -Name "CLIENT1-OS" -DiskSizeInGB 128 -CreateOption FromImage
New-AzVM -ResourceGroupName $rgName -Location $locName -VM $vm
#>
