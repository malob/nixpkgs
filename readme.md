(Note: This readme is pretty out of date.)

# Overview

This is my `nix` configuration that I use on all my systems. My overall goal/motivation is to make as much of my system configuration as possible declarative.

Notable features include:

  * Overlays to allow for a common environment setup on all machines ([common-env.nix](overlays/common-env.nix)), and OS specific environments [macos-env.nix](overlays/macos-env.nix) and [linux-env.nix](overlays/linux-env.nix) which inherit from the common environment.
  * Overlays that provide pure (located in the `nix` store) configuration for `git`, `kitty`, and `neovim`, so you don't need to manage dotfiles for all of them separately or use something like [`home-manager`](https://github.com/rycee/home-manager).
  * An overlay that adds the contents of the unstable channel into the `pkgs` set, making it easy to declaratively install packages from unstable by prepending the package name with `unstable`, e.g., `unstable.nodePackages.typescript`. (This is really nice for installing `vim` plugins since they are updated much less frequently in the stable channels.)
  * An easy way to install Node, Ruby, and Python packages that aren't available in `nixpkgs`. (See instructions below.)
  * A really easy way to declaratively manage GUI apps installed on macOS that aren't available in `nixpkgs` (most aren't) using `brew bundle`, which allows you to also install applications from the Mac App Store. (See macOS setup instructions below for details.)

# Instructions

## Setup

### macOS

Clone this repository into `~/.config/`:
```bash
git clone git@github.com:malob/nixpkgs.git ~/.config/nixpkgs
```

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

### Linux

TODO

## Updating
Run `nix-env -riA nixpkgs.[environment]` after editing the `nix` configuration, where `[environment]` should either be `myMacosEnv` or `myLinuxEnv`. (Note that `-r` wipes the whole user profile, so anything not installed declaratively through this configuration will be removed.)

As a bonus the `fish` config includes some handy functions for making things easier:

  * [nixuser-update-sources.fish](https://github.com/malob/config.fish/blob/master/functions/nixuser-update-sources.fish), updates `nix` channels, as well as regenerates the `nix` expressions for any Node, Ruby, and Python packages setup using the instructions below.
  * [nixuser-simlink-apps.fish](https://github.com/malob/config.fish/blob/master/functions/nixuser-simlink-apps.fish), looks for simlinks in `~/Applications` and deletes any that point to the `nix` store, then it creates new simlinks for everything in `~/.nix-profile/Applications`.
  * [nixuser-rebuild.fish](https://github.com/malob/config.fish/blob/master/functions/nixuser-rebuild.fish), checks what OS is running on the host machine and runs the appropriate `nix-env` command to reinstall the environment (if it's run on macOS, it automatically runs `nixuser-simlink-apps` as well). If run will `--all`, it will also run `nixuser-update-sources` prior to updating the environment.

## Installing Node packages
Node packages are managed with [`node2nix`](https://github.com/svanderburg/node2nix).

Packages you want to install should be added to `pkgs/node-packages/node-packages.json`, with a corresponding entry in the appropriate overlay.

You'll need to run `node2nix -8 -i node-packages` in `pkgs/node-packages/` whenever you add or remove entries in `node-packages.json`, or if you want to update packages that aren't pinned to a specific version number. This needs to be done prior to updating the `nix` environment.

## Installing Ruby Gems
Ruby gems are managed with [`bundix`](https://github.com/manveru/bundix).

Packages you want to install should be added to `pkgs/ruby-gems/Gemfile`, and you'll need to add a corresponding entry in `pkgs/ruby-gems/default.nix` and the appropriate overlay.

You'll need to run `bundix --magic` in `pkgs/ruby-gems/` whenever you add or remove entries in `Gemfile`, or if you want to update packages that aren't pinned to a specific version number. This needs to be done prior to updating the `nix` environment.

## Installing PyPI packages
Python packages are managed with [`pypi2nix`](https://github.com/garbas/pypi2nix).

Packages you want to install should be added to `pkgs/python-packages/requirements.txt`, with a corresponding entry in the appropriate overlay.

You'll need to run `pypi2nix --python-version 3.6 --requirements requirements.txt` in `pkgs/python-packages/` whenever you add or remove entries in `requirements.txt`, or if you want to update packages that aren't pinned to a specific version number. This needs to be done prior to updating the `nix` environment.
