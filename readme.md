# My Nix Configs

![Build Nix envs](https://github.com/malob/nixpkgs/workflows/Build%20Nix%20envs/badge.svg)

This repo contains my Nix configs for macOS and Linux and by extension, configuration for most tools/programs I use, at least in the terminal.

I'm continuously tweaking/improving my setup, trying to find ways to make more of my configuration declarative, and I like experimenting with bleeding edge updates/features, so this repo sees a lot of changes. I do try to ensure that `master` always builds and doesn't have any bad bugs (at least in my workflow), and keep the code fairly well documented.

Feel free to file an [issue](https://github.com/malob/nixpkgs/issues) or start a [discussion](https://github.com/malob/nixpkgs/discussions) if you find a bug, or think something is broken, or think I'm doing something in a dumb/clumsy way and have a suggestion for a more elegant alternative, or try to crib something from my config but just can't get it working, or are looking at my config and think to yourself "does this guy know about X, cause I bet he'd be into it", or have some other type of feedback/comment. (Issues, are better for things that are actually issues, while discussions are better for ideas, questions, etc.)

I make no promises that I'll respond quickly, or fix the bug (especially if I'm not experiencing it), or whatever, but you definitely shouldn't feel like you're imposing in any way, and I probably will respond within a few days.

Below, I've highlighted stuff that I'm particularly happy with or think others might find helpful/useful.

## Highlights

In no particular order:

* [Flakes](./flake.nix)!
  * All external dependencies managed through flakes for easy updating.
  * Outputs for [`nix-darwin`](https://github.com/LnL7/nix-darwin) macOS system configurations (using `home-manager` as a `nix-darwin` module) and a [`home-manager`](https://github.com/nix-community/home-manager) user configuration for Linux.
  * A function to simplify making `nix-darwin` system configurations (with `home-manager` integration), [`lib.mkDarwinSystem`](./lib/mkDarwinSystem.nix).
  * `darwinModules` output for `nix-darwin` modules with additional functionality and prepackaged configuration, including:
    * [`users-primaryUser`](./modules/darwin/users.nix) that provides `users.primaryUsers.{username,fullName,email,nixConfigDirectory}` options, which allows specifying this information one time by setting these options and then referencing their values when setting other options.
  * `homeManagerModules` output for `home-manager` modules with additional functionality and prepackaged configuration, including:
    * [`home-user-info`], that provides the same options as the my `nix-darwin` module `users-primaryUsers` above under `home.user-info`. See examples of it in use in [`home/git.nix`](./home/git.nix), [`home/neovim.nix`](./home/neovim.nix).
    * [`colors`](./modules/home/colors) which is a WIP module used to define colorschemes. See [`home/colors.nix`](./home/colors.nix), for an example of how to define a colorscheme.
    * [`programs-neovim-extras`](./modules/home/programs/neovim/extras.nix) that provides `programs.neovim.extras.{defaultEditor,nvrAliases,termBufferAutoChangeDir}` options.
    * [`programs-kitty-extras`](./modules/home/programs/kitty/extras.nix) that provides a,
      * `programs.kitty.extras.colors` option to configure a light and dark colorscheme, which when used also adds `term-light`, `term-dark`, and `term-background` scripts to `home.packages` to easily switch between them; and a
      * `programs.kitty.extras.useSymbolsFromNerdFont` option to use symbols from a NerdFont while using any font with Kitty.
    * [`malo-git-aliases`](./home/git-aliases.nix)
    * [`malo-gh-aliases`](./home/gh-aliases.nix)
    * [`malo-startship-symbols`](./home/starship-symbols.nix) that provides predefined configuration of symbols for [Starship](https://starship.rs) prompt using NerdFont symbols.
  * Support for non-flake compatible versions of Nix and legacy workflows through [`flake-compat`](https://nixos.wiki/wiki/Flakes#Using_flakes_project_from_a_legacy_Nix):
    * [`default.nix`](./default.nix), allows traditional Nix commands like `nix-build` to operate on the flake inputs/outputs.
* Support for Macs with Apple Silicon including ability to easily overlay in x86 version of packages, when they don't build on ARM. Search `pkgs-x86` in [`flake.nix`](./flake.nix) and see `nix.settings.extra-platforms` in [`darwin/bootstrap.nix`](./darwin/bootstrap.nix) for details.
* A GitHub [workflow](./.github/workflows/ci.yml) that builds the my macOS system `nix-darwin` config and `home-manager` Linux user config, and updates a Cachix cache. Also, once a week it updates all the flake inputs before building, and if the build succeeds, it commits the updated `flake.lock` file.
* [Git config](./home/git.nix) with a bunch of handy aliases and better diffs using [`delta`](https://github.com/dandavison/delta).
* A slick Neovim [config](./configs/nvim) in Lua. See also [`neovim.nix`](./home/neovim.nix).
* Unified colorscheme (based on [Solarized](https://ethanschoonover.com/solarized/)) with light and dark variant for [Kitty terminal](https://sw.kovidgoyal.net/kitty), [Fish shell](https://fishshell.com), [Neovim](https://neovim.io), and other tools, where toggling between light and dark can be done for all of them simultaneously by calling a Fish function. This is achieved by:
  * using the `colors` module mentioned above;
  * using my `programs-kitty-extras` `home-manager` module (see above);
  * using a self-made WIP Solarized based [colorscheme](./configs/nvim/lua/malo/theme.lua) with Neovim; and
  * a [Fish shell config](./home/fish.nix), which provides a `toggle-background` function (and an alias `tb`) which toggles a universal environment variable (`$term_background`) between the values `"light"` and `"dark"`, along with `set-shell-colors` function which trigger automatically when `$term_background` changes.
* A nice [shell prompt config](./home/starship.nix) for Fish using Starship.
