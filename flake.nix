{
  description = "Malo’s Nix system configs, and some other useful stuff.";

  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-21.05-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-21.05";
    nixpkgs-with-patched-kitty.url = "github:azuwis/nixpkgs/kitty";

    # Environment/system management
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Other sources
    comma = { url = "github:Shopify/comma"; flake = false; };
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";
    moses-lua = { url = "github:Yonaba/Moses"; flake = false; };
    nvim-lspinstall = { url = "github:kabouzeid/nvim-lspinstall"; flake = false; };
    prefmanager.url = "github:malob/prefmanager";
    prefmanager.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };


  outputs = { self, nixpkgs, darwin, home-manager, flake-utils, ... }@inputs:
  let
    # Some building blocks --------------------------------------------------------------------- {{{

    inherit (darwin.lib) darwinSystem;
    inherit (nixpkgs.lib) makeOverridable optionalAttrs singleton;

    # Configuration for `nixpkgs` mostly used in personal configs.
    nixpkgsConfig = with inputs; rec {
      config = { allowUnfree = true; };
      overlays = self.overlays ++ singleton (
        final: prev: ({

          master = import nixpkgs-master { inherit (prev) system; inherit config; };
          unstable = import nixpkgs-unstable {
            inherit (prev) system;
            inherit config;
            # Needed to get stuff like `vimPlugins` from `unstable` to use latest version
            overlays = [ (_: _: { tabnine = final.master.tabnine; }) ];
          };

          # Packages I want on the bleeding edge
          vimPlugins = prev.vimPlugins // final.unstable.vimPlugins;

          inherit (final.unstable)
            fish
            fishPlugins
            haskell
            haskellPackages
            kitty
            neovim
            neovim-unwrapped
            nixUnstable;

        # Packages which don't build on Apple Silicon yet
        } // optionalAttrs (prev.system == "aarch64-darwin") {

          master-x86 = import nixpkgs-master { system = "x86_64-darwin"; inherit config; };
          nixpkgs-x86= import nixpkgs { system = "x86_64-darwin";  inherit config;};
          unstable-x86 = import nixpkgs-unstable { system = "x86_64-darwin"; inherit config; };

          inherit (final.nixpkgs-x86)
            google-cloud-sdk
            idris2
            mosh
            niv
            nix-index;

          inherit (inputs.nixpkgs-with-patched-kitty.legacyPackages.aarch64-darwin) kitty;

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
      stateVersion = "21.05";
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
        final: prev: {
          # Some packages
          comma = import comma { inherit (prev) pkgs; };
          prefmanager = prefmanager.defaultPackage.${prev.system};

          # Vim plugins
          vimPlugins = prev.vimPlugins // prev.lib.genAttrs [
            "nvim-lspinstall"
          ] (final.lib.buildVimPluginFromFlakeInput inputs) // {
            moses-nvim = final.lib.buildNeovimLuaPackagePluginFromFlakeInput inputs "moses-lua";
          };

          # Fixes for packages that don't build for some reason.
          thefuck = prev.thefuck.overrideAttrs (old: { doInstallCheck = false; });
        }
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
      legacyPackages = import nixpkgs { inherit system; inherit (nixpkgsConfig) config overlays; };
  });
}
# vim: foldmethod=marker
