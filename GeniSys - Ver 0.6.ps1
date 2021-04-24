mode 300

Echo '
 0000000000000000   000000000000000     0000        00    000000000000000    000000000000000    00           00    000000000000000
00000000000000000  00000000000000000  0000000       000  00000000000000000  00000000000000000   000         000   00000000000000000
000                000                000  000      000         000         000                  000       000    000
000                000                000   000     000         000          000                  000     000      000
000      0000000   0000000000000000   000    000    000         000           000000000000         000000000        000000000000
000      00000000  0000000000000000   000     000   000         000            000000000000          00000           000000000000
000           000  000                000      000  000         000                      000          000                      000
000           000  000                000       000 000         000                       000         000                       000
00000000000000000  00000000000000000  000        000000  00000000000000000  00000000000000000         000         00000000000000000
 0000000000000000   000000000000000    00         0000    000000000000000    000000000000000          000          000000000000000
  
####################################################################################################################################
####################################################################################################################################'

Echo ('Welcome to GeniSys')

Start-Sleep -Seconds 3

# Get the ID and security principal of the current user account
$myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent();
$myWindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($myWindowsID);

# Get the security principal for the administrator role
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator;

# Check to see if we are currently running as an administrator
if ($myWindowsPrincipal.IsInRole($adminRole))
{
    # We are running as an administrator, so change the title and background colour to indicate this
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)";
    $Host.UI.RawUI.BackgroundColor = "DarkBlue";
    Clear-Host;
}
else {
    
    # Create a new process object that starts PowerShell
    $newProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell";

    # Specify the current script path and name as a parameter with added scope and support for scripts with spaces in it's path
    $newProcess.Arguments = "& '" + $script:MyInvocation.MyCommand.Path + "'"

    # Indicate that the process should be elevated
    $newProcess.Verb = "runas";

    # Start the new process
    [System.Diagnostics.Process]::Start($newProcess);

    # Exit from the current, unelevated, process
    Exit;
}

# Code for elevation pop here

#Need to turn this into an if/else statement and to ask if its required in the first place
#Asks for the IP address accociated with DNS and sets the DNS to that address
$DNS = Read-Host "Enter DNS Address"
Set-DnsClientServerAddress -InterfaceAlias 'Ethernet' , 'Ethernet 0' , 'Ethernet 1' , 'Ethernet 2' , 'Ethernet 3' , 'Ethernet 4' -ServerAddresses ("$DNS")

#Clears the Cache
Clear-DnsClientCache

#Asks for user input to enter in the Domain name, Domain Admin and the name of the server
$UserDomain = Read-Host "Enter Domain"
$DomainAdmin = Read-Host "Enter Domain Admin"
$Server = Read-Host "Enter Server Name"

#you can set this as as a variable or just have a simple user - more on this later
$Username = 'Term'

#I mean this just adds the computer to the domain using the credentials popped in by user input 
Add-Computer -DomainName $UserDomain -Credential $DomainAdmin -Force

#Adds the Domain user to the Local administrator Goup
Add-LocalGroupMember -Group "Administrators" -Member "$UserDomain\Term"

#Asks for username and gives full path fo HKLM
$Password = Read-Host "Enter a Password for Term if Necessary"
#$Username = $env:UserName #think this is only useful if you want the current signed in user to be the one that is used
$RegKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\winlogon"

#This was part of an orginal .bat file that i recreated in powershell, the idea is to force a login of a user from the domain
 New-ItemProperty -Path "$RegKeyPath" -Name "DefaultUsername" -Value "$Username" -PropertyType "String" -Force
 New-ItemProperty -Path "$RegKeyPath" -Name "DefaultDomain" -Value "$UserDomain" -PropertyType "String" -Force
 New-ItemProperty -Path "$RegKeyPath" -Name "DefaultDomainName" -Value "$UserDomain" -PropertyType "String" -Force
 New-ItemProperty -Path "$RegKeyPath" -Name "AltDefaultUserName" -Value "$Username" -PropertyType "String" -Force
 New-ItemProperty -Path "$RegKeyPath" -Name "AltDefaultDomainName" -Value "$UserDomain" -PropertyType "String" -Force
 New-ItemProperty -Path "$RegKeyPath" -Name "AutoAdminLogon" -Value "1" -PropertyType "String" -Force
 New-ItemProperty -Path "$RegKeyPath" -Name "DefaultPassword" -Value "$Password" -PropertyType "String" -Force
 New-ItemProperty -Path "$RegKeyPath" -Name "DisableCAD" -Value "1" -PropertyType "String" -Force

#This copies any item from the server folder path back to the local PC and should create the path required to store these items
Copy-Item "\\$Server\Quadranet\Quadranet\EposV5\App\EposV5\" -Destination "C:\Quadranet\" -Recurse -Force

#Get path to removeable drive and software folder

#Install TeamViewer

#Select and install Printer Driver then rename

Rename-Printer -Name "$printername" -NewName "Local"

#Select and Install OPOS Driver

#I mean self explanatory it restarts the PC
Restart-Computer
