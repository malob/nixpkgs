{
  description = "Malo’s Nix system configs, and some other useful stuff.";

  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable-darwin.url = "github:nixos/nixpkgs/nixpkgs-20.09-darwin";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-20.09";

    # Environment/system management
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Neovim plugins
    galaxyline-nvim = { url = "github:glepnir/galaxyline.nvim"; flake = false; };
    lush-nvim = { url = "github:rktjmp/lush.nvim"; flake = false; };
    moses-lua = { url = "github:Yonaba/Moses"; flake = false; };
    nvim-bufferline-lua = { url = "github:akinsho/nvim-bufferline.lua"; flake = false; };
    telescope-nvim = { url = "github:nvim-telescope/telescope.nvim"; flake = false; };
    telescope-symbols-nvim = { url = "github:nvim-telescope/telescope-symbols.nvim"; flake = false; };
    telescope-z-nvim = { url = "github:nvim-telescope/telescope-z.nvim"; flake = false; };
    vim-haskell-module-name = { url = "github:chkno/vim-haskell-module-name"; flake = false; };

    # Other sources
    comma = { url = "github:Shopify/comma"; flake = false; };
    fish-done = { url = "github:franciscolourenco/done"; flake = false; };
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";
    neovim.url = "github:neovim/neovim?dir=contrib";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
    prefmanager.url = "github:malob/prefmanager";
    prefmanager.inputs.nixpkgs.follows = "nixpkgs";
  };


  outputs = { self, nixpkgs, darwin, home-manager, flake-utils, ... }@inputs:
  let
    # Some building blocks --------------------------------------------------------------------- {{{

    # Configuration for `nixpkgs` mostly used in personal configs.
    nixpkgsConfig = with inputs; {
      config = { allowUnfree = true; };
      overlays = self.overlays ++ [
        (
          final: prev:
          let
            system = prev.stdenv.system;
            nixpkgs-stable = if system == "x86_64-darwin" then nixpkgs-stable-darwin else nixos-stable;
          in {
            master = nixpkgs-master.legacyPackages.${system};
            stable = nixpkgs-stable.legacyPackages.${system};
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
    nixDarwinCommonModules = { user }: [
      # Include extra `nix-darwin`
      self.darwinModules.programs.nix-index
      self.darwinModules.security.pam
      # Main `nix-darwin` config
      ./darwin
      # `home-manager` module
      home-manager.darwinModules.home-manager
      {
        nixpkgs = nixpkgsConfig;
        # Hack to support legacy worklows that use `<nixpkgs>` etc.
        nix.nixPath = { nixpkgs = "$HOME/.config/nixpkgs/nixpkgs.nix"; };
        # `home-manager` config
        users.users.${user}.home = "/Users/${user}";
        home-manager.useGlobalPkgs = true;
        home-manager.users.${user} = homeManagerCommonConfig;
      }
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
        modules = nixDarwinCommonModules { user = "malo"; } ++ [
          {
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
        modules = nixDarwinCommonModules { user = "runner"; } ++ [
          ({ lib, ... }: { homebrew.enable = lib.mkForce false; })
        ];
      };
    };

    # Config I use with Linux cloud VMs
    # Build and activate with `nix build .#cloudVM.activationPackage; ./result/activate`
    cloudVM = home-manager.lib.homeManagerConfiguration {
      system = "x86_64-linux";
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
          neovim-nightly = neovim.packages.${prev.stdenv.system}.neovim;
          prefmanager = prefmanager.defaultPackage.${prev.stdenv.system};

          # Vim plugins
          vimPlugins = prev.vimPlugins // prev.lib.genAttrs [
            "galaxyline-nvim"
            "lush-nvim"
            "nvim-bufferline-lua"
            "telescope-nvim"
            "telescope-symbols-nvim"
            "telescope-z-nvim"
            "vim-haskell-module-name"
          ] (final.lib.buildVimPluginFromFlakeInput inputs) // {
            moses-nvim = final.lib.buildNeovimLuaPackagePluginFromFlakeInput inputs "moses-lua";
          };

          # Fish shell plugins
          fishPlugins = prev.fishPlugins // {
            done = prev.fishPlugins.buildFishPlugin {
              pname = "done";
              version = "HEAD";
              src = inputs.fish-done;
            };
          };
        }
      )
      # Other overlays that don't depend on flake inputs.
    ] ++ map import ((import ./lsnix.nix) ./overlays);

    # My `nix-darwin` modules that are pending upstream, or patched versions waiting on upstream
    # fixes.
    darwinModules = {
      programs.nix-index = import ./darwin/modules/programs/nix-index.nix;
      security.pam = import ./darwin/modules/security/pam.nix;
    };

    homeManagerModules = {
      configs.git.aliases = import ./home/configs/git-aliases.nix;
      configs.gh.aliases = import ./home/configs/gh-aliases.nix;
      configs.starship.symbols = import ./home/configs/starship-symbols.nix;
      programs.neovim.extras = import ./home/modules/programs/neovim/extras.nix;
      programs.kitty.extras = import ./home/modules/programs/kitty/extras.nix;
    };
    # }}}

    # Add re-export `nixpkgs` packages with overlays.
    # This is handy in combination with `nix registry add my /Users/malo/.config/nixpkgs`
  } // flake-utils.lib.eachDefaultSystem (system: {
      legacyPackages = import nixpkgs { inherit system; inherit (nixpkgsConfig) config overlays; };
  });
}
# vim: foldmethod=marker
