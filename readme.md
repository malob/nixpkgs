(This readme is out of date)

# My Nix user config

Node packages are managed with [node2nix](https://github.com/svanderburg/node2nix). Packages you want to install should be added to `pkgs/node-packages/node-packages.json`. You'll need to run `node2nix -8 -i node-packages` whenever you add or remove packages.

To update the user profile run `nix-env -riA nixos.usersetup`.

To automate this process I create a `fish` function [`nix-rebuild-user`](https://github.com/malob/config.fish/blob/master/functions/nix-rebuild-user.fish).
