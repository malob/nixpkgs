# My Nix Configs

![Build Nix macOS env](https://github.com/malob/nixpkgs/workflows/Build%20Nix%20macOS%20env/badge.svg)

This is my Nix configuration (with a few other things thrown in) that I use on all my systems macOS, Ubuntu for VMs, NixOS (used at work with company system configs). My overall goal/motivation is to make as much of my system configuration as possible declarative.

* [`nix-darwin`](https://github.com/LnL7/nix-darwin) is used for managing macOS [system config](./darwin/configuration.nix).
* [`home-manager`](https://github.com/nix-community/home-manager) (as `nix-darwin` module on macOS) is used for managing [user config](./home-manager/configuration.nix).
* [`brew bundle`](https://github.com/Homebrew/homebrew-bundle) is used to manage macOS GUI apps that aren't easy to manage with Nix, see [`Brewfile`](./Brewfile).
* Misc configs are stored in [`configs`](./configs).

## Notable Features

* [`niv`](https://github.com/nmattia/niv) as a replacement for `nix-channels` and for better source management throughout the config.
  * Instead of using `nix-channels`, channels are added to [`nix/sources.json`](./nix/sources.json), and [`nix/nix-defexpr`](./nix/nix-defexpr) is simlinked to `~/.nix-defexpr`.
  * The `unstable` channel is used by default, but both the latest `stable` channel as well as `master` are added to `pkgs` via an [overlay](./overlays/channels.nix) for easy access when needed.
* [Git config](home-manager/git.nix) with a bunch of handy aliases and better diffs using [`delta`](https://github.com/dandavison/delta),
* Unified colorscheme (based on colors from [NeoSolarized](https://github.com/overcache/NeoSolarized)) for [Kitty terminal](https://sw.kovidgoyal.net/kitty/#), [Fish shell](https://fishshell.com), [Neovim](https://neovim.io), and other tools, where toggling between light and dark can be done for all of them simultaneously by calling a Fish function. This is achieved by:
  * adding NeoSolarized colors to `pkgs` via an [overlay](./overlays/neosolarized-colors.nix);
  * defining an [overlay](./overlays/kitty-configs.nix) for Kitty terminal configs that uses these colors to define a main config, as well as additional light and dark sub-configs (where Kitty's initial config is setup in [home-manager/configuration.nix](./home-manager/configuration.nix));
  * using the NeoSolarized colorscheme in the Neovim config with `set t_Co=16` so all other plugins etc. source colors from terminal colors; and
  * setting up a [Fish shell config](./home-manager/shells.nix), references the NeoSolarized colors from the overlay, provides a `toggle-colors` function that toggles an environment variable (`$term_colors`) between `light` and `dark`, and a `terminal-colors` function that is automatically called when `$term_colors` is changed that runs a series of commands to change the colors/themes used by Kitty, Fish, Neovim, Bat, and Delta.
* A nice [shell prompt config](./home-manager/shells.nix) for Fish using [Starship](https://starship.rs).
* A feature packed and slick looking Neovim config ([`init.vim`](./configs/nvim/init.vim), [`coc-settings.json`](./configs/nvim/coc-settings.json), [`neovim.nix`](./home-manager/neovim.nix)).
* A GitHub [workflow](./.github/workflows/ci.yml) that builds the `nix-darwin` config and updates a Cachix cache. Once a week it also tries to update channels/sources before building, and if successful, it commits the changes.
