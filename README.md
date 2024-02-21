# custom-nushell-commands
 Some custom commands for nu

## Usage

Get the nushell env file path:
```shell
$nu.env-path
# C:\Users\lucac\AppData\Roaming\nushell\env.nu
```

At the end of the file, load the custom commands:
```shell
use "C:/Users/lucac/Documents/GitHub/custom-nushell-commands/user.nu"
user present
```

You can now use the `user` module, for example:
```shell
user symlink --help
```