{
  description = "Malo’s Nix system configs, and some other useful stuff.";

  inputs = {
    # Package sets
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-22.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-22.05";

    # Environment/system management
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.utils.follows = "flake-utils";

    # Other sources
    cornelis.url = "github:isovector/cornelis";
    cornelis.inputs.nixpkgs.follows = "nixpkgs-unstable";
    cornelis.inputs.flake-compat.follows = "flake-compat";
    cornelis.inputs.flake-utils.follows = "flake-utils";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";
    prefmanager.url = "github:malob/prefmanager";
    prefmanager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    prefmanager.inputs.flake-compat.follows = "flake-compat";
    prefmanager.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, darwin, home-manager, flake-utils, ... }@inputs:
    let
      inherit (self.lib) attrValues makeOverridable optionalAttrs singleton;

      # Configuration for `nixpkgs`
      nixpkgsConfig = {
        config = {
          allowUnfree = true;
        };
        overlays = attrValues (self.overlays // inputs.cornelis.overlays) ++ [
          # Sub in x86 version of packages that don't build on Apple Silicon yet
          (final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            inherit (final.pkgs-x86)
              agda
              idris2;
          }))
        ];
      };

      defaultPrimaryUser = {
        username = "malo";
        fullName = "Malo Bourgon";
        email = "mbourgon@gmail.com";
        nixConfigDirectory = "/Users/malo/.config/nixpkgs";
      };
    in
    {

      # System outputs ------------------------------------------------------------------------- {{{

      lib = inputs.nixpkgs-unstable.lib.extend (_: _: {
        mkDarwinSystem = import ./lib/mkDarwinSystem.nix inputs;
      });

      # Mininal macOS configurations to bootstrap systems
      darwinConfigurations.bootstrap-x86 = makeOverridable darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [ ./darwin/bootstrap.nix { nixpkgs = nixpkgsConfig; } ];
      };
      darwinConfigurations.bootstrap-arm = self.darwinConfigurations.bootstrap-x86.override {
        system = "aarch64-darwin";
      };

      # My Apple Silicon macOS laptop config
      darwinConfigurations.MaloBookPro = makeOverridable self.lib.mkDarwinSystem {
        inherit (defaultPrimaryUser) username fullName email nixConfigDirectory;
        modules = attrValues self.darwinModules ++ singleton {
          nixpkgs = nixpkgsConfig;
          networking.computerName = "Malo’s 💻";
          networking.hostName = "MaloBookPro";
          networking.knownNetworkServices = [
            "Wi-Fi"
            "USB 10/100/1000 LAN"
          ];
          nix.registry.my.flake = inputs.self;
        };
        homeModules = attrValues self.homeManagerModules;
      };

      # Config with small modifications needed/desired for CI with GitHub workflow
      darwinConfigurations.githubCI = self.darwinConfigurations.MaloBookPro.override {
        system = "x86_64-darwin";
        username = "runner";
        nixConfigDirectory = "/Users/runner/work/nixpkgs/nixpkgs";
        extraModules = singleton { homebrew.enable = self.lib.mkForce false; };
      };

      # Config I use with Linux cloud VMs
      # Build and activate on new system with:
      # `nix build .#homeConfigurations.malo.activationPackage; ./result/activate`
      homeConfigurations.malo = home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs-unstable {
          system = "x86_64-linux";
          inherit (nixpkgsConfig) config overlays;
        };
        modules = attrValues self.homeManagerModules ++ singleton ({ config, ... }: {
          home.username = config.home.user-info.username;
          home.homeDirectory = "/home/${config.home.username}";
          home.stateVersion = "22.11";
          home.user-info = defaultPrimaryUser // {
            nixConfigDirectory = "${config.home.homeDirectory}/.config/nixpkgs";
          };
        });
      };
      # }}}

      # Non-system outputs --------------------------------------------------------------------- {{{

      overlays = {
        # Overlays to add different versions `nixpkgs` into package set
        pkgs-master = _: prev: {
          pkgs-master = import inputs.nixpkgs-master {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };
        pkgs-stable = _: prev: {
          pkgs-stable = import inputs.nixpkgs-stable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };
        pkgs-unstable = _: prev: {
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };

        prefmanager = _: prev: {
          inherit (inputs.prefmanager.packages.${prev.stdenv.system}) prefmanager;
        };

        # Overlay that adds various additional utility functions to `vimUtils`
        vimUtils = import ./overlays/vimUtils.nix;

        # Overlay that adds some additional Neovim plugins
        vimPlugins = final: prev:
          let
            inherit (self.overlays.vimUtils final prev) vimUtils;
          in
          {
            vimPlugins = prev.vimPlugins.extend (_: _:
              vimUtils.buildVimPluginsFromFlakeInputs inputs [
                # Add flake input name here
              ] // {
                # Add plugins here
                inherit (inputs.cornelis.packages.${prev.stdenv.system}) cornelis-vim;
              }
            );
          };

        # Overlay useful on Macs with Apple Silicon
        apple-silicon = _: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          # Add access to x86 packages system is running Apple Silicon
          pkgs-x86 = import inputs.nixpkgs-unstable {
            system = "x86_64-darwin";
            inherit (nixpkgsConfig) config;
          };
        };

        # Overlay to include node packages listed in `./pkgs/node-packages/package.json`
        # Run `nix run my#nodePackages.node2nix -- -14` to update packages.
        nodePackages = _: prev: {
          nodePackages = prev.nodePackages // import ./pkgs/node-packages { pkgs = prev; };
        };
      };

      darwinModules = {
        # My configurations
        malo-bootstrap = import ./darwin/bootstrap.nix;
        malo-defaults = import ./darwin/defaults.nix;
        malo-general = import ./darwin/general.nix;
        malo-homebrew = import ./darwin/homebrew.nix;

        # Modules I've created
        programs-nix-index = import ./modules/darwin/programs/nix-index.nix;
        users-primaryUser = import ./modules/darwin/users.nix;
      };

      homeManagerModules = {
        # My configurations
        malo-colors = import ./home/colors.nix;
        malo-config-files = import ./home/config-files.nix;
        malo-fish = import ./home/fish.nix;
        malo-git = import ./home/git.nix;
        malo-git-aliases = import ./home/git-aliases.nix;
        malo-gh-aliases = import ./home/gh-aliases.nix;
        malo-kitty = import ./home/kitty.nix;
        malo-neovim = import ./home/neovim.nix;
        malo-packages = import ./home/packages.nix;
        malo-starship = import ./home/starship.nix;
        malo-starship-symbols = import ./home/starship-symbols.nix;

        # Modules I've created
        colors = import ./modules/home/colors;
        programs-neovim-extras = import ./modules/home/programs/neovim/extras.nix;
        programs-kitty-extras = import ./modules/home/programs/kitty/extras.nix;
        home-user-info = { lib, ... }: {
          options.home.user-info =
            (self.darwinModules.users-primaryUser { inherit lib; }).options.users.primaryUser;
        };
      };
      # }}}

    } // flake-utils.lib.eachDefaultSystem (system: {
      # Add re-export `nixpkgs` packages with overlays.
      # This is handy in combination with `nix registry add my /Users/malo/.config/nixpkgs`
      legacyPackages = import inputs.nixpkgs-unstable {
        inherit system;
        inherit (nixpkgsConfig) config;
        overlays = attrValues {
          inherit (self.overlays)
            pkgs-master
            pkgs-stable
            apple-silicon
            nodePackages
            ;
        };
      };

      # Shell environments for development
      devShells =
        let
          pkgs = self.legacyPackages.${system};
        in
        {
          python = pkgs.mkShell {
            name = "python310";
            inputsFrom = attrValues {
              inherit (pkgs.pkgs-master.python310Packages) black isort;
              inherit (pkgs) poetry python310 pyright;
            };
          };
        };
    });
}
# vim: foldmethod=marker
