# Install WSL2
wsl --install -d Ubuntu-20.04

# Install OpenSSH
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~
Start-Service sshd  -StartupType 'Automatic'
Get-NetFirewallRule -DisplayName 'OpenSSH Server (sshd)'

# Allow ICMPv4 echo request in firewall
netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol="icmpv4:8,any" dir=in action=allow
netsh advfirewall firewall add rule name="ICMP Allow incoming V6 echo request" protocol="icmpv6:8,any" dir=in action=allow