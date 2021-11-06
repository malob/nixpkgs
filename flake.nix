{
  description = "Malo’s Nix system configs, and some other useful stuff.";

  inputs = {
    # Package sets
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-21.05-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-21.05";
    nixpkgs-with-patched-kitty.url = "github:azuwis/nixpkgs/kitty";

    # Environment/system management
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Other sources
    comma = { url = "github:Shopify/comma"; flake = false; };
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";
    moses-lua = { url = "github:Yonaba/Moses"; flake = false; };
    nvim-lspinstall = { url = "github:kabouzeid/nvim-lspinstall"; flake = false; };
    prefmanager.url = "github:malob/prefmanager";
    prefmanager.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };


  outputs = { self, darwin, home-manager, flake-utils, ... }@inputs:
  let
    # Some building blocks --------------------------------------------------------------------- {{{

    inherit (darwin.lib) darwinSystem;
    inherit (inputs.nixpkgs-unstable.lib) makeOverridable optionalAttrs singleton;

    # Configuration for `nixpkgs` mostly used in personal configs.
    nixpkgsConfig = rec {
      config = { allowUnfree = true; };
      overlays = self.overlays ++ singleton (
        # Sub in x86 version of packages that don't build on Apple Silicon yet
        final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          inherit (final.pkgs-x86)
            idris2
            nix-index
            niv
          ;
        })
      );
    };

    # Personal configuration shared between `nix-darwin` and plain `home-manager` configs.
    homeManagerCommonConfig = with self.homeManagerModules; {
      imports = [
        ./home
        configs.git.aliases
        configs.gh.aliases
        configs.starship.symbols
        programs.neovim.extras
        programs.kitty.extras
      ];
    };

    # Modules shared by most `nix-darwin` personal configurations.
    nixDarwinCommonModules = [
      # Include extra `nix-darwin`
      self.darwinModules.programs.nix-index
      self.darwinModules.security.pam
      self.darwinModules.users
      # Main `nix-darwin` config
      ./darwin
      # `home-manager` module
      home-manager.darwinModules.home-manager
      (
        { config, lib, pkgs, ... }:
        let
          inherit (config.users) primaryUser;
        in {
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
  in {

    # Personal configuration ------------------------------------------------------------------- {{{

    # My `nix-darwin` configs
    darwinConfigurations = rec {
      # Mininal configurations to bootstrap systems
      bootstrap-x86 = makeOverridable darwinSystem {
        system = "x86_64-darwin";
        modules = [ ./darwin/bootstrap.nix { nixpkgs = nixpkgsConfig; } ];
      };
      bootstrap-arm = bootstrap-x86.override { system = "aarch64-darwin"; };

      # My old Intel macOS laptop config
      MaloBookPro = darwinSystem {
        system = "x86_64-darwin";
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

      # My new Apple Silicon macOS laptop config
      MaloBookProM1 = darwinSystem {
        system = "aarch64-darwin";
        modules = nixDarwinCommonModules ++ [
          {
            users.primaryUser = "malo";
            networking.computerName = "Malo’s M1 💻";
            networking.hostName = "MaloBookProM1";
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
      stateVersion = "21.11";
      homeDirectory = "/home/malo";
      username = "malo";
      configuration = {
        imports = [ homeManagerCommonConfig ];
        nixpkgs = nixpkgsConfig;
      };
    };
    # }}}

    # Outputs useful to others ----------------------------------------------------------------- {{{

    overlays = with inputs; [
      (
        final: prev: ({
          # Add access to other versions of `nixpkgs`
          pkgs-master = import inputs.nixpkgs-master { inherit (prev.stdenv) system; inherit (nixpkgsConfig) config; };
          pkgs-stable = import inputs.nixpkgs-stable { inherit (prev.stdenv) system; inherit (nixpkgsConfig) config; };

          # Until https://github.com/NixOS/nixpkgs/pull/144651 lands on unstable branch
          inherit (final.pkgs-master) thefuck;

          # Some extra packages
          comma = import comma { inherit (prev) pkgs; };
          prefmanager = prefmanager.defaultPackage.${prev.system};

          # Some extra Vim plugins
          vimPlugins = prev.vimPlugins // prev.lib.genAttrs [
            "nvim-lspinstall"
          ] (final.lib.buildVimPluginFromFlakeInput inputs) // {
            moses-nvim = final.lib.buildNeovimLuaPackagePluginFromFlakeInput inputs "moses-lua";
          };

        } // optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          # Add access to x86 packages system is running Apple Silicon
          pkgs-x86 = import inputs.nixpkgs-unstable { system = "x86_64-darwin"; inherit (nixpkgsConfig) config; };

          # Get Apple Silicon version of `kitty`
          # TODO: Remove when https://github.com/NixOS/nixpkgs/pull/137512 lands
          inherit (inputs.nixpkgs-with-patched-kitty.legacyPackages.aarch64-darwin) kitty;
        })
      )
      # Other overlays that don't depend on flake inputs.
    ] ++ map import ((import ./lsnix.nix) ./overlays);

    # My `nix-darwin` modules that are pending upstream, or patched versions waiting on upstream
    # fixes.
    darwinModules = {
      programs.nix-index = import ./modules/darwin/programs/nix-index.nix;
      security.pam = import ./modules/darwin/security/pam.nix;
      users = import ./modules/darwin/users.nix;
    };

    homeManagerModules = {
      configs.git.aliases = import ./home/configs/git-aliases.nix;
      configs.gh.aliases = import ./home/configs/gh-aliases.nix;
      configs.starship.symbols = import ./home/configs/starship-symbols.nix;
      programs.neovim.extras = import ./modules/home/programs/neovim/extras.nix;
      programs.kitty.extras = import ./modules/home/programs/kitty/extras.nix;
    };
    # }}}

    # Add re-export `nixpkgs` packages with overlays.
    # This is handy in combination with `nix registry add my /Users/malo/.config/nixpkgs`
  } // flake-utils.lib.eachDefaultSystem (system: {
      legacyPackages = import inputs.nixpkgs-unstable { inherit system; inherit (nixpkgsConfig) config overlays; };
  });
}
# vim: foldmethod=marker
