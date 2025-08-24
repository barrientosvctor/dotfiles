# My dotfiles

> [!CAUTION]
> This is my own dotfiles, if you are going to run some of these dotfiles in your machine, do it at your own risk.

## Unix

Work in progress...

## Windows

Make sure to run the `setup.ps1` script with administrator rights and from the root of the dotfiles folder for successfully install the configuration.

```shell
PS> .\setup.ps1
```

### Script parameters

**Note**: Running the script with no parameters. Runs a basic setup.

#### Optional parameters

- `_ForcePSProfile`: Forces the renaming of PSProfile.
- `FullSetup`: Installs all features and programs.
- `InstallVim`: Installs vim.
- `SetupVim`: Configures vimrc.
- `FullVim`: Executes `InstallVim` and `SetupVim` procedures.