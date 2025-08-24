Param(
    [switch]$_ForcePSProfile,

    [Parameter(HelpMessage = "Installs PSProfile, fzf and vim. Also setup vim as well.")]
    [switch]$FullSetup,

    [switch]$InstallVim,
    [switch]$SetupVim,
    [switch]$FullVim
)

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
    if ($_ForcePSProfile -eq $true) {
        New-Item -ItemType "SymbolicLink" -Path "$PROFILE" -Value "$PWD\.config\powershell\profile.ps1" -Verbose -Force
    }
    else {
        if ((Test-Path $PROFILE) -eq $false) {
            New-Item -ItemType "SymbolicLink" -Path "$PROFILE" -Value "$PWD\.config\powershell\profile.ps1" -Verbose
        }
    }
}

function installFzf {
    if (-not (Get-Command "fzf" -ErrorAction SilentlyContinue)) { 
        winget install fzf
    }
    
    if (-not (Get-Package "PSFzf" -ErrorAction SilentlyContinue)) {
        Install-Module -Name PSFzf
    }
}

function installVim {
    if (-not (Get-Command "vim" -ErrorAction SilentlyContinue)) {
        winget install --interactive -e --id vim.vim
    }
}

function setupVimrc {
    New-Item -ItemType SymbolicLink -Path "$env:HOMEPATH\_vimrc" -Value "$PWD\.config\vim\.vimrc" -Force
    
    # Vim-Plug installation
    Invoke-WebRequest -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | New-Item $HOME/vimfiles/autoload/plug.vim -Force
    
    vim -es -u $env:HOMEPATH\_vimrc -i NONE -c "PlugInstall" -c "qa"
}

setPSProfile
installFzf

if ($FullSetup -eq $true) {
    installVim
    setupVimrc
}
else {
    if ($FullVim -eq $true) {
        installVim
        setupVimrc
    }
    else {
        if ($InstallVim -eq $true) {
            installVim
        }
        if ($SetupVim -eq $true) {
            setupVimrc
        }
    }
}
