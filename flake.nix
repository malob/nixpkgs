{
  description = "Malo’s Nix system configs, and some other useful stuff.";

  inputs = {
    # Package sets
    nixpkgs-master.url = github:NixOS/nixpkgs/master;
    nixpkgs-stable.url = github:NixOS/nixpkgs/nixpkgs-21.11-darwin;
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    nixos-stable.url = github:NixOS/nixpkgs/nixos-21.11;

    # Environment/system management
    darwin.url = github:LnL7/nix-darwin;
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Other sources
    flake-compat = { url = github:edolstra/flake-compat; flake = false; };
    flake-utils.url = github:numtide/flake-utils;
    moses-lua = { url = github:Yonaba/Moses; flake = false; };
    prefmanager.url = github:malob/prefmanager;
    prefmanager.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = { self, darwin, home-manager, flake-utils, ... }@inputs:
    let
      # Some building blocks ------------------------------------------------------------------- {{{

      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;

      # Configuration for `nixpkgs`
      nixpkgsConfig = {
        config = { allowUnfree = true; };
        overlays = attrValues self.overlays ++ singleton (
          # Sub in x86 version of packages that don't build on Apple Silicon yet
          final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            inherit (final.pkgs-x86)
              idris2;
          })
        );
      };

      # Personal configuration shared between `nix-darwin` and plain `home-manager` configs.
      homeManagerStateVersion = "22.05";
      homeManagerCommonConfig = {
        imports = attrValues self.homeManagerModules ++ [
          ./home
          { home.stateVersion = homeManagerStateVersion; }
        ];
      };

      # Modules shared by most `nix-darwin` personal configurations.
      nixDarwinCommonModules = attrValues self.darwinModules ++ [
        # Main `nix-darwin` config
        ./darwin
        # `home-manager` module
        home-manager.darwinModules.home-manager
        (
          { config, lib, pkgs, ... }:
          let
            inherit (config.users) primaryUser;
          in
          {
            nixpkgs = nixpkgsConfig;
            # Hack to support legacy worklows that use `<nixpkgs>` etc.
            nix.nixPath = { nixpkgs = "$HOME/.config/nixpkgs/nixpkgs.nix"; };
            # `home-manager` config
            users.users.${primaryUser}.home = "/Users/${primaryUser}";
            home-manager.useGlobalPkgs = true;
            home-manager.users.${primaryUser} = homeManagerCommonConfig;
            # Add a registry entry for this flake
            nix.registry.my.flake = self;
          }
        )
      ];
      # }}}
    in
    {

      # Personal configuration ----------------------------------------------------------------- {{{

      # My `nix-darwin` configs
      darwinConfigurations = rec {
        # Mininal configurations to bootstrap systems
        bootstrap-x86 = makeOverridable darwinSystem {
          system = "x86_64-darwin";
          modules = [ ./darwin/bootstrap.nix { nixpkgs = nixpkgsConfig; } ];
        };
        bootstrap-arm = bootstrap-x86.override { system = "aarch64-darwin"; };

        # My Apple Silicon macOS laptop config
        MaloBookPro = darwinSystem {
          system = "aarch64-darwin";
          modules = nixDarwinCommonModules ++ [
            {
              users.primaryUser = "malo";
              networking.computerName = "Malo’s 💻";
              networking.hostName = "MaloBookPro";
              networking.knownNetworkServices = [
                "Wi-Fi"
                "USB 10/100/1000 LAN"
              ];
            }
          ];
        };

        # Config with small modifications needed/desired for CI with GitHub workflow
        githubCI = darwinSystem {
          system = "x86_64-darwin";
          modules = nixDarwinCommonModules ++ [
            ({ lib, ... }: {
              users.primaryUser = "runner";
              homebrew.enable = lib.mkForce false;
            })
          ];
        };
      };

      # Config I use with Linux cloud VMs
      # Build and activate with `nix build .#cloudVM.activationPackage; ./result/activate`
      cloudVM = home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        stateVersion = homeManagerStateVersion;
        homeDirectory = "/home/malo";
        username = "malo";
        configuration = {
          imports = [ homeManagerCommonConfig ];
          nixpkgs = nixpkgsConfig;
        };
      };
      # }}}

      # Outputs useful to others --------------------------------------------------------------- {{{

      overlays = {
        # Overlays to add different versions `nixpkgs` into package set
        pkgs-master = final: prev: {
          pkgs-master = import inputs.nixpkgs-master {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };
        pkgs-stable = final: prev: {
          pkgs-stable = import inputs.nixpkgs-stable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };
        pkgs-unstable = final: prev: {
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };

        prefmanager = final: prev: {
          prefmanager = inputs.prefmanager.defaultPackage.${prev.stdenv.system};
        };

        # Overlay that adds various additional utility functions to `vimUtils`
        vimUtils = import ./overlays/vimUtils.nix;

        # Overlay that adds some additional Neovim plugins
        vimPlugins = final: prev:
          let
            inherit (self.overlays.vimUtils final prev) vimUtils;
          in
          {
            vimPlugins = prev.vimPlugins.extend (super: self:
              (vimUtils.buildVimPluginsFromFlakeInputs inputs [
                # Add plugins here
              ]) // {
                moses-nvim = vimUtils.buildNeovimLuaPackagePluginFromFlakeInput inputs "moses-lua";
              }
            );
          };

        # Overlay useful on Macs with Apple Silicon
        apple-silicon = final: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          # Add access to x86 packages system is running Apple Silicon
          pkgs-x86 = import inputs.nixpkgs-unstable {
            system = "x86_64-darwin";
            inherit (nixpkgsConfig) config;
          };
        };

        # Overlay to include node packages listed in `./pkgs/node-packages/package.json`
        # Run `nix run my#nodePackages.node2nix -- -14` to update packages.
        nodePackages = final: prev: {
          nodePackages = prev.nodePackages // import ./pkgs/node-packages { pkgs = prev; };
        };

        # Overlay to add some additional python packages
        pythonPackages = import ./overlays/python.nix;

        # Overlay that adds `lib.colors` to reference colors elsewhere in system configs
        colors = import ./overlays/colors.nix;
      };

      # My `nix-darwin` modules that are pending upstream, or patched versions waiting on upstream
      # fixes.
      darwinModules = {
        programs-nix-index = import ./modules/darwin/programs/nix-index.nix;
        security-pam = import ./modules/darwin/security/pam.nix;
        users = import ./modules/darwin/users.nix;
      };

      homeManagerModules = {
        configs-git-aliases = import ./home/configs/git-aliases.nix;
        configs-gh-aliases = import ./home/configs/gh-aliases.nix;
        configs-starship-symbols = import ./home/configs/starship-symbols.nix;
        programs-neovim-extras = import ./modules/home/programs/neovim/extras.nix;
        programs-kitty-extras = import ./modules/home/programs/kitty/extras.nix;
      };
      # }}}

      # Add re-export `nixpkgs` packages with overlays.
      # This is handy in combination with `nix registry add my /Users/malo/.config/nixpkgs`
    } // flake-utils.lib.eachDefaultSystem (system: {
      legacyPackages = import inputs.nixpkgs-unstable {
        inherit system;
        inherit (nixpkgsConfig) config;
        overlays = with self.overlays; [
          pkgs-master
          pkgs-stable
          apple-silicon
          nodePackages
        ];
      };
    });
}
# vim: foldmethod=marker
