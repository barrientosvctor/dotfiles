from os import getenv, path, getcwd
from platform import system

available_os = ["windows", "unix"]
available_shells = [
    ("WSL", "Pwsh", "Powershell", "Command Prompt"), # Windows
    ("bash", "zsh"), # Unix
]

shell_cmd = [
    ("wsl", "pwsh", "powershell", "cmd"), #Windows
    ("/bin/bash", "/bin/zsh"), #Unix
]
wsl_root: str = "~"

if system() == "Windows":
    win_root = getenv("HOMEPATH")

    if win_root:
        wsl_root = "/mnt/c/{}".format(win_root.replace('\\', '/'))

alacritty_terminal_args = {
    # Windows
    0: {
        0: ("wsl.exe", "--cd", wsl_root),
        1: ("-NoLogo", "-NoExit", "-Command", "cd ~"),
        2: ("-NoLogo", "-NoExit", "-Command", "cd ~"),
        3: ("/k", "cd %USERPROFILE%"),
    },
    # Unix
    1: {
        # Bash
        0: ("-c", "cd ~"),
        # Zsh
        1: ("-c", "cd ~")
    },
}

def list_available_os():
    for num_option in range(0, len(available_os)):
        print(f"{num_option}. {available_os[num_option]}")
        num_option += 1

def list_available_shell_by_os(num_os):
    for shell_option in range(0, len(available_shells[num_os])):
        print(f"{shell_option}. ${available_shells[num_os][shell_option]}")
        shell_option += 1


def make_toml_array(tpl: tuple):
    array_literal = '['

    for i in range(0, tpl.__len__()):
        if i+1 >= tpl.__len__():
            array_literal += f'"{tpl[i]}"]'
        else:
            array_literal += f'"{tpl[i]}",'

    return array_literal

def alacritty(os_num: int, shell_num: int):
    chosen_terminal_args = tuple(alacritty_terminal_args[os_num][shell_num])
    args = make_toml_array(chosen_terminal_args)
    alacritty_config_path = path.join(getcwd(), ".config", "alacritty", "alacritty.toml")

    with open(alacritty_config_path, "a+") as f:
        if f.writable():
            f.write("\n")
            f.write("[shell]\n")
            f.write(f'program = "{shell_cmd[os_num][shell_num]}"\n')
            f.write("args = " + args + '\n')

        if not f.closed:
            f.close()

list_available_os()

os_option = int(input("Choose the operative system you are using: "))

while os_option < 0 or os_option > len(available_os) - 1:
    list_available_os()
    os_option = int(input("That option doesn't exists, choose another: "))

list_available_shell_by_os(os_option)

shell_option = int(input("Type the shell you want to use for Alacritty: "))

while not (shell_option >= 0 and shell_option < len(available_shells[os_option])):
    list_available_shell_by_os(os_option)
    shell_option = int(input("That option doesn't exists, choose another: "))

alacritty(os_option, shell_option)
