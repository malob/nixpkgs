# My Nix Configs

![Build Nix envs](https://github.com/malob/nixpkgs/workflows/Build%20Nix%20envs/badge.svg)

## Notable Features

* Flakes!
* A GitHub [workflow](./.github/workflows/ci.yml) that builds the `nix-darwin` config and updates a Cachix cache. Once a week it also tries to update channels/sources before building, and if successful, it commits the changes.
* Some custom `nix-darwin` modules:
  * [`homebrew`](./darwin/modules/homebrew.nix) which manages packages/apps installed via Hombrew Bundle. See example usage in [`darwin/homebrew.nix`](./darwin/homebrew.nix). (Pending upstream PR [#262](https://github.com/LnL7/nix-darwin/pull/262).)
  * [`security.pam`](./darwin/modules/security/pam.nix) which provides an option, `enableSudoTouchIdAuth`, which enables using Touch ID for `sudo` authentication. (Pending upstream PR [#228](https://github.com/LnL7/nix-darwin/pull/228).)
* [Git config](home-manager/git.nix) with a bunch of handy aliases and better diffs using [`delta`](https://github.com/dandavison/delta),
* Unified colorscheme (based on colors from [NeoSolarized](https://github.com/overcache/NeoSolarized)) for [Kitty terminal](https://sw.kovidgoyal.net/kitty/#), [Fish shell](https://fishshell.com), [Neovim](https://neovim.io), and other tools, where toggling between light and dark can be done for all of them simultaneously by calling a Fish function. This is achieved by:
  * adding NeoSolarized colors to `pkgs` via an [overlay](./overlays/neosolarized-colors.nix);
  * defining an [overlay](./overlays/kitty-configs.nix) for Kitty terminal configs that uses these colors to define a main config, as well as additional light and dark sub-configs (where Kitty's initial config is setup in [home-manager/configuration.nix](./home-manager/configuration.nix));
  * using the NeoSolarized colorscheme in the Neovim config with `set t_Co=16` so all other plugins etc. source colors from terminal colors; and
  * setting up a [Fish shell config](./home-manager/shells.nix), references the NeoSolarized colors from the overlay, provides a `toggle-colors` function that toggles an environment variable (`$term_colors`) between `light` and `dark`, and a `terminal-colors` function that is automatically called when `$term_colors` is changed that runs a series of commands to change the colors/themes used by Kitty, Fish, Neovim, Bat, and Delta.
  * On macOS there is also a service `launchd` user service, `setTermColors`, that changes `$term_colors` automatically to match the OS's setting.
* A nice [shell prompt config](./home-manager/shells.nix) for Fish using [Starship](https://starship.rs).
* An experimental (but functional) slick Neovim 0.5.0 (nightly) config in Lua ([`init.lua`](./configs/nvim/lua/init.lua), [`neovim.nix`](./home-manager/neovim.nix)).
