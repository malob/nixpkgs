{
  description = "Malo’s Nix System Configs";

  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable-darwin.url = "github:nixos/nixpkgs/nixpkgs-20.09-darwin";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-20.09";

    # Environment/system management
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Neovim plugins
    galaxyline-nvim = { url = "github:glepnir/galaxyline.nvim"; flake = false; };
    gitsigns-nvim = { url = "github:lewis6991/gitsigns.nvim"; flake = false; };
    lush-nvim = { url = "github:rktjmp/lush.nvim"; flake = false; };
    moses-lua = { url = "github:Yonaba/Moses"; flake = false; };
    telescope-nvim = { url = "github:nvim-telescope/telescope.nvim"; flake = false; };
    vim-haskell-module-name = { url = "github:chkno/vim-haskell-module-name"; flake = false; };

    # Other sources
    comma = { url = "github:Shopify/comma"; flake = false; };
    fish-done = { url = "github:franciscolourenco/done"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";
    neovim.url = "github:neovim/neovim?dir=contrib";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin, home-manager, flake-utils, ... }@inputs: let

    nixpkgsConfig = {
      config = { allowUnfree = true; };
      overlays = inputs.self.overlays;
    };

    # Modules shared by most `nix-darwin` configurations.
    nixDarwinCommonModules = { user }: [
      # Include extra `nix-darwin`
      self.darwinModules.homebrew
      self.darwinModules.programs.fish
      self.darwinModules.security.pam
      # Main `nix-darwin` config
      ./darwin
      # `home-manager` config
      home-manager.darwinModules.home-manager
      {
        users.users.${user}.home = "/Users/${user}";
        home-manager.useGlobalPkgs = true;
        home-manager.users.${user} = import ./home;
        nixpkgs = nixpkgsConfig;
      }
    ];

  in {

    overlays = with inputs; [
      (
        final: prev: let
          system = prev.stdenv.system;
          nixpkgs-stable = if system == "x86_64-darwin" then nixpkgs-stable-darwin else nixos-stable;
        in {
          # Various nixpkgs channels
          master = nixpkgs-master.legacyPackages.${system};
          stable = nixpkgs-stable.legacyPackages.${system};

          # Additional packages
          comma = import comma { inherit (prev) pkgs; };
          neovim-nightly = neovim.packages.${system}.neovim;

          # Vim plugins
          vimPlugins = with prev.vimUtils; prev.vimPlugins // prev.lib.genAttrs [
            "galaxyline-nvim"
            "lush-nvim"
            "vim-haskell-module-name"
            "gitsigns-nvim"
            "telescope-nvim"
          ] (name: buildVimPluginFrom2Nix { inherit name; src = inputs.${name}; }) // {
            moses-nvim = buildVimPluginFrom2Nix {
              name = "moses-nvim";
              src = prev.linkFarm "moses-nvim" [ { name = "lua"; path = inputs.moses-lua; } ];
            };
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
      homebrew = import ./darwin/modules/homebrew.nix;
      programs.fish = import ./darwin/modules/programs/fish.nix;
      security.pam = import ./darwin/modules/security/pam.nix;
    };

    darwinConfigurations = {
      # Mininal configuration to bootstrap systems
      bootstrap = darwin.lib.darwinSystem {
        inputs = inputs;
        modules = [ ./darwin/bootstrap.nix self.darwinModules.programs.fish ];
      };

      # My macOS main laptop config
      MaloBookPro = darwin.lib.darwinSystem {
        inputs = inputs;
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

    # Config used on linux cloud VMs
    # Build and activate with `nix build .#cloudVM.activationPackage; ./result/activate`
    cloudVM = home-manager.lib.homeManagerConfiguration {
      system = "x86_64-linux";
      homeDirectory = "/home/malo";
      username = "malo";
      configuration = {
        imports = [ ./home ];
        nixpkgs = nixpkgsConfig;
      };
    };

    # Add `nixpkgs` flake contents to outputs with overlays
    inherit (nixpkgs) lib checks htmlDocs nixosModules;
  } // flake-utils.lib.eachDefaultSystem (system: {
      legacyPackages = import nixpkgs { inherit system; inherit (nixpkgsConfig) config overlays; };
  });
}
