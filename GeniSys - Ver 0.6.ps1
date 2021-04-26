mode 300

Write-Output '
 0000000000000000   000000000000000     0000        00    000000000000000    00000000000000   00          00    00000000000000
00000000000000000  00000000000000000  0000000       000  00000000000000000  0000000000000000  000         000  0000000000000000
000                000                000  000      000         000         000                000       000   000
000                000                000   000     000         000          000                000     000     000
000      0000000   0000000000000000   000    000    000         000           000000000000       000000000       000000000000
000      00000000  0000000000000000   000     000   000         000            000000000000        00000          000000000000
000           000  000                000      000  000         000                      000        000                     000
000           000  000                000       000 000         000                       000       000                      000
00000000000000000  00000000000000000  000        000000  00000000000000000  00000000000000000       000        00000000000000000
 0000000000000000   000000000000000    00         0000    000000000000000    000000000000000        000         000000000000000
  
####################################################################################################################################
####################################################################################################################################'

Echo ('Welcome to GeniSys, Installer Kit')

Start-Sleep -Seconds 2

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

# Need to turn this into an if/else statement and to ask if its required in the first place
$useranswer = Read-Host "Do You Need to Enter DNS Address"

if ("YES", "Yes", "yes", "Y", "y" -eq $useranswer) {

    # Asks for the IP address accociated with DNS and sets the DNS to that address
    $DNS = Read-Host "Enter DNS Address"
    Set-DnsClientServerAddress -InterfaceAlias 'Ethernet' , 'Ethernet 0' , 'Ethernet 1' , 'Ethernet 2' , 'Ethernet 3' , 'Ethernet 4' -ServerAddresses ("$DNS") -ErrorAction SilentlyContinue
    # Clears the Cache 
    Clear-DnsClientCache
}
elseif ("NO", "No", "no", "N", "n" -eq $useranswer) {
    Write-Output "Carrying on With Install"
}

# Asks for user input to enter in the Domain name, Domain Admin and the name of the server
$UserDomain = Read-Host "Enter Domain"
$DomainAdmin = Read-Host "Enter Domain Admin"
$Server = Read-Host "Enter Server Name"

# You can set this as as a variable or just have a simple user
$Username = 'Term'

# I mean this just adds the computer to the domain using the credentials popped in by user input 
Add-Computer -DomainName $UserDomain -Credential $DomainAdmin -Force

# Adds the Domain user to the Local administrator Goup
Add-LocalGroupMember -Group "Administrators" -Member "$UserDomain\Term"

# Asks for username and gives full path fo HKLM
$Password = Read-Host "Enter a Password for Term if Necessary"

# $Username = $env:UserName #think this is only useful if you want the current signed in user to be the one that is used
$RegKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\winlogon"

# This was part of an orginal .bat file that i recreated in powershell, the idea is to force a login of a user from the domain
 New-ItemProperty -Path "$RegKeyPath" -Name "DefaultUsername" -Value "$Username" -PropertyType "String" -Force
 New-ItemProperty -Path "$RegKeyPath" -Name "DefaultDomain" -Value "$UserDomain" -PropertyType "String" -Force
 New-ItemProperty -Path "$RegKeyPath" -Name "DefaultDomainName" -Value "$UserDomain" -PropertyType "String" -Force
 New-ItemProperty -Path "$RegKeyPath" -Name "AltDefaultUserName" -Value "$Username" -PropertyType "String" -Force
 New-ItemProperty -Path "$RegKeyPath" -Name "AltDefaultDomainName" -Value "$UserDomain" -PropertyType "String" -Force
 New-ItemProperty -Path "$RegKeyPath" -Name "AutoAdminLogon" -Value "1" -PropertyType "String" -Force
 New-ItemProperty -Path "$RegKeyPath" -Name "DefaultPassword" -Value "$Password" -PropertyType "String" -Force
 New-ItemProperty -Path "$RegKeyPath" -Name "DisableCAD" -Value "1" -PropertyType "String" -Force

# This copies any item from the server folder path back to the local PC and should create the path required to store these items
Copy-Item "\\$Server\Quadranet\Quadranet\EposV5\App\EposV5\" -Destination "C:\Quadranet\" -Recurse -Force

# Get path to removeable drive and software folder
$genisys = (get-volume | where drivetype -eq removable).driveletter
$new = $genisys + ":"
$TV = "TeamViewer.exe"
$SP-1030 = ""
SP-1060 = ""
$Audrey = "Audrey_OPOS_Driver.exe"

# Install TeamViewer
Start-Process "$new\RequiredSoftware\TeamViewer.exe" -UseNewEnvironment

Start-Sleep -Seconds 20

# Select and install Printer Driver then rename
# Need to find a way to list the printers then take user input and pass to if else statements
Start-Process "$new\Creation Kit\TeamViewer.exe" -UseNewEnvironment

$selectedprinter = $selecteddriver
if ($selectedprinter -eq "RP-320") {

    Start-Process -FilePath "Driver.exe" 
    Write-Output "$selectedprinter will be renamed."
}
elseif ($selectedprinter -eq "RP-600") {

    Start-Process -FilePath "Driver.exe"
    Write-Output "$selectedprinter will be renamed."
}
elseif ($selectedprinter -eq "RP-700") {

    Start-Process -FilePath "Driver.exe"
    Write-Output "$selectedprinter will be renamed."
}

$printername = $selectedprinter

Start-Sleep -Seconds 60 #curious to see if i can make this wait for printer installation then continue

Rename-Printer -Name "$printername" -NewName "Local"

# Select and Install OPOS Driver this will need to vary based upon the terminal
if ($OPOSDriver -eq "need to get drivers" "SP-1030") {

    Start-Process -FilePath "Driver.exe" 
    Write-Output "$OPOSDriver will need to be set to ".
}
elseif ($OPOSDriver -eq "need to get drivers" "SP-1060") {

    Start-Process -FilePath "Driver.exe"
    Write-Output "$OPOSDriver will need to be set to ".
}
elseif ($OPOSDriver -eq "need to get drivers" "Audrey") {

    Start-Process -FilePath "Driver.exe"
    Write-Output "$OPOSDriver will need to be set to KS-A".
}

Start-Sleep -Seconds 20

# I mean self explanatory it restarts the PC
Restart-Computer
