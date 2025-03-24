# Victor's dotfiles

## Notes
- Make sure to run the script on a terminal with administrator permissions.
- Make sure to stay at dotfiles root path when running any script

## Windows setup

### Requeriments
* PowerShell >= 5.1.*

### Installation

> **Installation including all targets**

```shell
$ .\scripts\setup.ps1 all
```

> **Installation of a specific target**

```shell
$ .\scripts\setup.ps1 <target>
```

> **List of all targets available**

```shell
$ .\scripts\setup.ps1 help
```

## Unix setup
Dotfiles (un)installation are managed by scripts located un [scripts](/scripts/) folder, you need to convert the script file you want to execute as Bash Script Executable file.

> **Installation**
* Linux OS / Termux: [install.sh](/scripts/install.sh)

You need to convert to Bash Script Executable file all scripts located in [scripts](/scripts/) folder, for this, type the following command:

```
$ chmod u+x ./scripts/*.sh
```

### Installation

```
$ ./scripts/install.sh
```
