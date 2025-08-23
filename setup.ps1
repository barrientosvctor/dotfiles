# Setup script for PowerShell 5.1 or greater.

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($isAdmin -ne $true) {
    Write-Host "PowerShell is NOT running with administrator privileges." -ForegroundColor Red
    exit 1
}

Write-Host "Make sure you're running this script from the root of your dotfiles folder." -ForegroundColor Yellow

$confirmation = (Read-Host "Do you want to continue? (y/n): ").ToLower()

while ($confirmation -ne "y" -and $confirmation -ne "n") {
    $confirmation = (Read-Host "Are you sure you want to continue? (y/n): ").ToLower()
}

if ($confirmation -eq "n") {
    Write-Host "Thanks for using!"
    exit 0
}

function setPSProfile {
    if ((Test-Path $PROFILE) -eq $false) {
        New-Item -ItemType "SymbolicLink" -Path "$PROFILE" -Value "$PWD\.config\powershell\profile.ps1"
    }
}

function installFzf {
    if ((Get-Command "fzf") -eq $false) { 
        winget install fzf
    }
    
    if ((Get-Package "PSFzf") -eq $false) {
        Install-Module -Name PSFzf
    }
}

setPSProfile
installFzf