[Object[]]$input
$input=get-WindowsCapability -Online | Where-Object -Property Name -Match "^OpenSSH.*"
[Microsoft.Dism.Commands.BasicCapabilityObject]$server
$server=$input| Where-Object -Property Name -Match ".*Server.*"
[Microsoft.Dism.Commands.BasicCapabilityObject]$client
$client=$input| Where-Object -Property Name -Match ".*Client.*"

if ($server.State -ne 'Installed') {
    # Install the OpenSSH Client
    Add-WindowsCapability -Online -Name $server.Name
}
if ($client.State -ne 'Installed') {
    # Install the OpenSSH Server
    Add-WindowsCapability -Online -Name $client.Name
}


Start-Service sshd
# OPTIONAL but recommended:
Set-Service -Name sshd -StartupType 'Automatic'
# Confirm the Firewall rule is configured. It should be created automatically by setup. 
Get-NetFirewallRule -Name *ssh*
# There should be a firewall rule named "OpenSSH-Server-In-TCP", which should be enabled
# If the firewall does not exist, create one
$input=Get-NetFirewallRule |Where-Object -Property name -Match ^sshd$
if($input -eq $null){
    New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
}
    