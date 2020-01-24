$theLoggedInUser = $(whoami) # Returns domain name and username
$theLoggedInUserName = $theLoggedInUser.Substring(4)
Write-Host $theLoggedInUserName

