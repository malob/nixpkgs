{
  description = "Malo’s Nix system configs, and some other useful stuff.";

  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-21.05-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-21.05";

    # Environment/system management
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Other sources
    comma = { url = "github:Shopify/comma"; flake = false; };
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";
    moses-lua = { url = "github:Yonaba/Moses"; flake = false; };
    neovim.url = "github:neovim/neovim?dir=contrib";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
    prefmanager.url = "github:malob/prefmanager";
    prefmanager.inputs.nixpkgs.follows = "nixpkgs";
  };


  outputs = { self, nixpkgs, darwin, home-manager, flake-utils, ... }@inputs:
  let
    # Some building blocks --------------------------------------------------------------------- {{{

    # Configuration for `nixpkgs` mostly used in personal configs.
    nixpkgsConfig = with inputs; rec {
      config = { allowUnfree = true; };
      overlays = self.overlays ++ [
        (
          final: prev: {
            master = import nixpkgs-master { inherit (prev) system; inherit config; };
            unstable = import nixpkgs-unstable { inherit (prev) system; inherit config; };

            # Packages I want on the bleeding edge
            fish = final.unstable.fish;
            kitty = final.unstable.kitty;
          }
        )
      ];
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
      ( { config, lib, ... }: let inherit (config.users) primaryUser; in {
        nixpkgs = nixpkgsConfig;
        # Hack to support legacy worklows that use `<nixpkgs>` etc.
        nix.nixPath = { nixpkgs = "$HOME/.config/nixpkgs/nixpkgs.nix"; };
        # `home-manager` config
        users.users.${primaryUser}.home = "/Users/${primaryUser}";
        home-manager.useGlobalPkgs = true;
        home-manager.users.${primaryUser} = homeManagerCommonConfig;
      })
    ];
    # }}}
  in {

    # Personal configuration ------------------------------------------------------------------- {{{

    # My `nix-darwin` configs
    darwinConfigurations = {
      # Mininal configuration to bootstrap systems
      bootstrap = darwin.lib.darwinSystem {
        modules = [ ./darwin/bootstrap.nix { nixpkgs = nixpkgsConfig; } ];
      };

      # My macOS main laptop config
      MaloBookPro = darwin.lib.darwinSystem {
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
      githubCI = darwin.lib.darwinSystem {
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
          neovim-nightly = neovim.packages.${prev.system}.neovim;
          prefmanager = prefmanager.defaultPackage.${prev.system};

          # Vim plugins
          vimPlugins = prev.vimPlugins // {
            moses-nvim = final.lib.buildNeovimLuaPackagePluginFromFlakeInput inputs "moses-lua";
          };

          # Fixes for packages that don't build for some reason.
          neovim-remote = prev.neovim-remote.overrideAttrs (old: { doInstallCheck = false; });
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
