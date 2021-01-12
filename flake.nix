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

    # Fish plugins
    fish-done = { url = "github:franciscolourenco/done"; flake = false; };
    fish-humanize-duration = { url = "github:fishpkg/fish-humanize-duration"; flake = false; };

    # Neovim plugins
    galaxyline-nvim = { url = "github:glepnir/galaxyline.nvim"; flake = false; };
    gitsigns-nvim = { url = "github:lewis6991/gitsigns.nvim"; flake = false; };
    lush-nvim = { url = "github:rktjmp/lush.nvim"; flake = false; };
    moses-lua = { url = "github:Yonaba/Moses"; flake = false; };
    telescope-nvim = { url = "github:nvim-telescope/telescope.nvim"; flake = false; };
    vim-haskell-module-name = { url = "github:chkno/vim-haskell-module-name"; flake = false; };

    # Other sources
    comma = { url = "github:Shopify/comma"; flake = false; };
    neovim.url = "github:neovim/neovim?dir=contrib";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, darwin, home-manager, ... }@inputs: let

    # `nix-darwin`/`home-manager` module that adds an overlay from flakes inputs, as well as those
    # defined in `./overlays`.
    overlaysModule = with inputs; system: { pkgs, ... }: let
      nixpkgs-stable = if pkgs.stdenv.isDarwin then nixpkgs-stable-darwin else nixos-stable;
    in {
      nixpkgs.overlays = [
        (
          self: super: {
            master = nixpkgs-master.legacyPackages.${system};
            stable = nixpkgs-stable.legacyPackages.${system};
            comma = import comma { inherit pkgs; };
            neovim-nightly = neovim.packages.${system}.neovim;
          }
        )
      ] ++ map import ((import ./lsnix.nix) ./overlays);
    };

    # `home-manager` config used on Linux and on macOS when using `home-manager` as a `nix-darwin`
    # module. The `homeManagerAsModule` argument is used to indicate whether `home-manager` is being
    # used as a module inside `nix-darwin`. When it is not, additional configuration is required.
    homeManagerCommonModule = { homeManagerAsModule ? true }: {
      # Make flake inputs available as argument to `home-manager` modules.
      _module.args.sources = inputs;
      # Import bulk of configuration, and include overlays module if and additonal configuration if
      # `home-manager` is being used on it's own on a Linux system. When using `home-manager` as a
      # `nix-darwin` module, overlays are added to the `nix-darwin` config, which also makes them
      # available in the `home-manager` configuration.
      imports = [ ./home-manager/configuration.nix ] ++ (
        if !homeManagerAsModule then [
          (overlaysModule "x86_64-linux")
          { nixpkgs.config = import ./config.nix; }
        ] else []
      );
    };

    # Modules shared by most `nix-darwin` configurations.
    nixDarwinCommonModules = { user }: [
      # Add in overlays
      (overlaysModule "x86_64-darwin")
      # Bulk of configuration
      ./darwin/configuration.nix
      # Add `home-manager` as a module
      home-manager.darwinModules.home-manager
      # Misc settings and `home-manager` config
      {
        # Make flake inputs available as argument to `nix-darwin` modules.
        _module.args.inputs = inputs;
        # `home-manager` configuration
        users.users.${user}.home = "/Users/${user}";
        home-manager.useGlobalPkgs = true;
        home-manager.users.${user} = homeManagerCommonModule {};
      }
    ];

  in {

    darwinConfigurations = {
      # Mininal configuration to bootstrap systems
      bootstrap = darwin.lib.darwinSystem {
        modules = [ ./darwin/bootstrap.nix ];
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

    # Config used on linux cloud VMs
    # Build and activate with `nix build .#cloudVM.activationPackage; ./result/activate`
    cloudVM = home-manager.lib.homeManagerConfiguration {
      system = "x86_64-linux";
      homeDirectory = "/home/malo";
      username = "malo";
      configuration = homeManagerCommonModule { homeManagerAsModule = false; };
    };

  };
}
