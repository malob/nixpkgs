# Instructions

## macOS

### Setup a new masOS computer

Install the `nix` package manager in multi-user mode:
```bash
sh <(curl https://nixos.org/nix/install) --daemon
```
(You should probably check that this is still the correct command in the [`nix` manual](https://nixos.org/nix/manual/#sect-multi-user-installation))


Add the `nixpkgs-unstable` channel for the user, and change the system channel to the latest stable darwin channel:
```bash
nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable; nix-channel --update
sudo nix-channel --remove unstable
sudo nix-channel --add https://nixos.org/channels/nixpkgs-19.03-darwin stable; sudo nix-channel --update
```
(Check the list of [available channels](https://nixos.org/channels/) to make sure your using the most up to date stable channel.)

Install `nixpkgs.myMacosEnv`, to install all packages managed by `nix`:
```bash
nix-env -riA nixpkgs.myMacosEnv
```

Install `brew`, then install the contents of the `Brewfile`, to to install all packages and GUI apps not managed by `nix`:
```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew bundle
```

Finally install [`fish` configuration](https://github.com/malob/config.fish) and then run `chsh -s $(which fish)`.

### Updating
Run `nix-env -riA nixpkgs.myMacosEnv` after editing the `nix` configuration.

## Installing Node packages
Node packages are managed with [`node2nix`](https://github.com/svanderburg/node2nix).

Packages you want to install should be added to `pkgs/node-packages/node-packages.json`, with a corresponding entry in the appropriate overlay.

You'll need to run `node2nix -8 -i node-packages` in `pkgs/node-packages/` whenever you add or remove entiries in `node-packages.json`, or if you want to update packages that aren't pinned to a specific version number. This needs to be done prior to updating the `nix` environment.

## Installing Ruby Gems
Ruby gems are managed with [`bundix`](https://github.com/manveru/bundix).

Packages you want to install should be added to `pkgs/ruby-gems/Gemfile`, and you'll need to add a corresponding entry in `pkgs/ruby-gems/default.nix` and the appropriate overlay.

You'll need to run `bundix --magic` in `pkgs/ruby-gems/` whenever you add or remove entries in `Gemfile`, or if you want to update packages that aren't pinned to a specific version number. This needs to be done prior to updating the `nix` environment.
