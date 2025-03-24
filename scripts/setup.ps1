Param(
    # Target passed as input.
    ##! Modify the help message when a new target is created.
    [Parameter(Mandatory, HelpMessage = 'Targets: all, help, modules, alacritty, symlink, profile' )]
    [string]$Target
)

# Ensure the script can run with elevated privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run this script as an Administrator!"
    break
}

[int] $processCount

##! Modify this hash table every time a new target is needed to create.
# 'targetName' = 'FunctionName'
# When the input matches with some key in the hash table, the function name passed as value will be invoke.
$hashTableTargets = @{
    'all' = "Dotfiles_PS_InvokeAllTargets";
    'help' = "Dotfiles_PS_ShowScriptInfo";
    'modules' = "Dotfiles_PS_InstallModules";
    'alacritty' = "Dotfiles_PS_SetupAlacrittyConfigFile";
    'symlink' = "Dotfiles_PS_SetupSymlinks";
    'profile' = "Dotfiles_PS_SetupPSProfile";
}

# Formats the hash table to a comprehensible string
$availableTargets = $hashTableTargets.Keys.ForEach({"`n-> $PSItem"})

# Take care of the edition of powershell you're executing the script to invoke a new terminal with the same type of edition.
function Internal_Dotfiles_PS_InvokeTerminal {
    Param(
            [Parameter(Mandatory, HelpMessage="Put the commands you want to execute. To run more than one command, separate them by (;)")]
            [string] $Command,
            [Parameter(Mandatory=$false, HelpMessage="Specify if the  new terminal instance must the interactive or not.")]
            [bool] $Interactive
         )

    if (-not ($Interactive -eq $true)) {
        $Interactive = $false
    }

    if ($PSVersionTable.PSEdition -eq "Core") {
        if ($Interactive -eq $true) {
            pwsh.exe -Interactive -NoLogo -Command $Command
        } else {
            pwsh.exe -NonInteractive -NoLogo -Command $Command
        }
    } elseif ($PSVersionTable.PSEdition -eq "Desktop") {
        if ($Interactive -eq $true) {
            powershell.exe -Interactive -NoLogo -Command $Command
        } else {
            powershell.exe -NonInteractive -NoLogo -Command $Command
        }
    }
}

# Used to when `all` target is matched.
##! Modify it when a new target function is created.
function Dotfiles_PS_InvokeAllTargets {
    Dotfiles_PS_InstallModules
    Dotfiles_PS_SetupAlacrittyConfigFile
    Dotfiles_PS_SetupPSProfile
    Dotfiles_PS_SetupSymlinks
    Write-Host "All targets were installed. Restart your computer to see the changes." -ForegroundColor White -BackgroundColor Green
}

# Used to show the amount of changes made in a target.
function Dotfiles_PS_CountChanges {
    param(
        [Parameter(Mandatory)]
        [int]$Count,

        [Parameter(Mandatory)]
        [string]$ProcessName
     )

    if ($Count -eq 0) {
        Write-Host "--> There were no changes in $ProcessName process. <--" -ForegroundColor Green
    } elseif ($Count -gt 0) {
        Write-Host "--> $ProcessName process successfully executed with $Count changes. <--" -Foregr Green
    } else {
        Write-Host "--> $ProcessName process successfully executed with unknown number of changes. <--" -Foregr Green
    }
}

# Checks if the module was installed before with `Install-Module`, if not, installs it.
function Internal_Dotfiles_PS_CheckAndInstallModule {
    Param(
        [Parameter(Mandatory, HelpMessage = "The module's name.")]
        [string] $ModuleName
     )

    if ($null -eq (Get-Module $ModuleName -ListAvailable)) {
        Write-Host "Installing $ModuleName..." -ForegroundColor DarkCyan
        Install-Module $ModuleName
        Write-Host "--> $ModuleName installed." -ForegroundColor Green
        $processCount = $processCount + 1
    }
}

# Installs winget packages
function Internal_Dotfiles_PS_CheckAndInstallWinGetPackage {
    Param(
        [Parameter(Mandatory, HelpMessage = "The winget package's id.")]
        [string] $PackageId,
        [Parameter(Mandatory=$false, HelpMessage = "Specify other parameters to execute along winget.")]
        [string] $AdditionalWingetParameters,
        [Parameter(Mandatory=$false, HelpMessage = "Specify if the  new terminal instance must the interactive or not.")]
        [bool] $InteractiveTerminal
     )

    $searchResult = winget.exe list --id $PackageId --exact
    $matchPackageId = $searchResult | Select-String $PackageId

    # If winget package was not found. Install it
    if ($null -eq $matchPackageId) {
        Write-Host "Installing $PackageId..." -ForegroundColor DarkCyan
        Internal_Dotfiles_PS_InvokeTerminal -Command "winget.exe install --id=$PackageId -e $AdditionalWingetParameters" -Interactive $InteractiveTerminal
        Write-Host "--> $PackageId installed." -ForegroundColor Green
        $processCount = $processCount + 1
    }
}

function Dotfiles_PS_InstallModules {
    $processCount = 0

    # If not running this script on powershell core >= 7.4
    if (-not ($PSVersionTable.PSEdition -eq "Core" -and $PSVersionTable.PSVersion.Major -ge 7 -and $PSVersionTable.PSVersion.Minor -ge 4)) {
        Internal_Dotfiles_PS_CheckAndInstallModule -ModuleName PSReadLine
    }

    Internal_Dotfiles_PS_CheckAndInstallModule -ModuleName PSFzf

    if (Get-Command winget.exe) {
        Internal_Dotfiles_PS_CheckAndInstallWinGetPackage -PackageId "junegunn.fzf"
        Internal_Dotfiles_PS_CheckAndInstallWinGetPackage -PackageId "Git.Git"
    } else {
        Write-Warning "!!--> Winget binary couldn't found. I'll omit the winget packages instalation."
        Write-Warning "!!--> Once you get the winget binary came back to run this target."
    }

    Dotfiles_PS_CountChanges -Count $processCount -ProcessName "Modules"
}

# Make a symbolic link to the powershell config
function Dotfiles_PS_SetupPSProfile {
    $processCount = 0
    $psConfigPath = Split-Path $PROFILE.CurrentUserCurrentHost

    if (-not (Test-Path -Path $psConfigPath)) {
        Write-Host "'$psConfigPath' directory not found, creating..." -ForegroundColor Cyan
        New-Item -ItemType Directory -Path $psConfigPath
        $processCount = $processCount + 1
    }

    # PROFILE is the path of the powershell config file.
    if (-not (Test-Path -Path $PROFILE -PathType Leaf)) {
        Write-Host "'$PROFILE' not found, making a symlink..." -ForegroundColor Cyan
        New-Item -ItemType SymbolicLink -Path $PROFILE -Value "$PWD\.config\powershell\Microsoft.PowerShell_profile.ps1"
        $processCount = $processCount + 1
    }

    Dotfiles_PS_CountChanges -Count $processCount -ProcessName "Powershell profile"
}

# This function assumes you're located in dotfiles's root directory
function Dotfiles_PS_SetupAlacrittyConfigFile {
    $processCount = 0

    [string]$Alacritty_Path = "$env:APPDATA\alacritty"
    [string]$Alacritty_File = "$env:APPDATA\alacritty\alacritty.toml"

    if (-Not (Test-Path -Path $Alacritty_Path)) {
        Write-Host "'$Alacritty_Path' not found. Creating..." -ForegroundColor Cyan
        New-Item -ItemType Directory -Path $Alacritty_Path
        $processCount = $processCount + 1
    }

    if (-Not (Test-Path -Path "$Alacritty_Path\alacritty.toml")) {
        Write-Host "'$Alacritty_File' not found. Creating a symlink..." -ForegroundColor Cyan
        New-Item -Path $Alacritty_File -ItemType SymbolicLink -Value "$PWD\.config\alacritty\alacritty.toml"
        $processCount = $processCount + 1
    }

    Dotfiles_PS_CountChanges -Count $processCount -ProcessName "Alacritty"
}

function Dotfiles_PS_SetupSymlinks {
    $processCount = 0

    if (-not (Test-Path -Path "$env:HOMEPATH\.gitconfig")) {
        New-Item -Path "$env:HOMEPATH\.gitconfig" -ItemType SymbolicLink -Value "$PWD\.gitconfig"
        $processCount = $processCount + 1
    }

    if (-not (Test-Path -Path "$env:HOMEPATH\.editorconfig")) {
        New-Item -Path "$env:HOMEPATH\.editorconfig" -ItemType SymbolicLink -Value "$PWD\.editorconfig"
        $processCount = $processCount + 1
    }

    Dotfiles_PS_CountChanges -Count $processCount -ProcessName "Symlink"
}

# Used to when `help` target is matched.
function Dotfiles_PS_ShowScriptInfo {
    Write-Host "Usage: .\setup.ps1 -Target <target>"
    Write-Host "Available targets: $availableTargets"
}

if ($hashTableTargets.ContainsKey($Target)) {
    Invoke-Expression -Command $hashTableTargets[$Target]
} else {
    Write-Host "Unrecognized target. Available targets: $availableTargets" -ForegroundColor Gray
}
