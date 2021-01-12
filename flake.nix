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

    # Vim plugins
    galaxyline-nvim = { url = "github:glepnir/galaxyline.nvim"; flake = false; };
    gitsigns-nvim = { url = "github:lewis6991/gitsigns.nvim"; flake = false; };
    lush-nvim = { url = "github:rktjmp/lush.nvim"; flake = false; };
    moses-lua = { url = "github:Yonaba/Moses"; flake = false; };
    telescope-nvim = { url = "github:nvim-telescope/telescope.nvim"; flake = false; };
    vim-haskell-module-name = { url = "github:chkno/vim-haskell-module-name"; flake = false; };

    # Other sources
    comma = { url = "github:Shopify/comma"; flake = false; };
    neovim = { url = "github:neovim/neovim?dir=contrib"; flake = false; };
  };

  outputs = { self, ... }@inputs:
    let

      overlaysModule = system: { pkgs, ... }: {
        nixpkgs.overlays = [
          (
            self: super: {
              master = inputs.nixpkgs-master.legacyPackages.${system};
              stable =
                if pkgs.stdenv.isDarwin then
                  inputs.nixpkgs-stable-darwin.legacyPackages.${system}
                else
                  inputs.nixos-stable.legacyPackages.${system};
              comma = import inputs.comma { inherit pkgs; };
              neovim-nightly = inputs.neovim.packages.${system}.neovim;
            }
          )
        ] ++ map import ((import ./lsnix.nix) ./overlays);
      };

      nixDarwinCommonModules = [
        { _module.args.inputs = inputs; }
        (overlaysModule "x86_64-darwin")
        ./darwin/configuration.nix
      ];

      homeManagerCommonModule = {
        _module.args.sources = inputs;
        imports = [ ./home-manager/configuration.nix ];
      };

    in
      {

        darwinConfigurations = {

          # Mininal configuration to bootstrap systems
          bootstrap = inputs.darwin.lib.darwinSystem {
            modules = [ ./darwin/bootstrap.nix ];
          };

          # My macOS main laptop config
          MaloBookPro = inputs.darwin.lib.darwinSystem {
            modules = nixDarwinCommonModules ++ [
              {
                users.users.malo.home = "/Users/malo";
                networking.computerName = "Malo’s 💻";
                networking.hostName = "MaloBookPro";
                networking.knownNetworkServices = [
                  "Wi-Fi"
                  "USB 10/100/1000 LAN"
                ];
              }
              inputs.home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.users.malo = homeManagerCommonModule;
              }
            ];
          };

          # Config with small modifications needed/desired for CI with GitHub workflow
          githubCI = inputs.darwin.lib.darwinSystem {
            modules = nixDarwinCommonModules ++ [
              (
                { lib, ... }: {
                  users.users.runner.home = "/Users/runner";
                  homebrew.enable = lib.mkForce false;
                }
              )
              inputs.home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.users.runner = homeManagerCommonModule;
              }
            ];
          };

        };

        # Config used on linux cloud VMs
        # Build and activate with `nix build .#cloudVM.activationPackage; ./result/activate`
        cloudVM = inputs.home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          homeDirectory = "/home/malo";
          username = "malo";
          configuration = homeManagerCommonModule // {
            imports = [ overlaysModule "x86_64-linux" ];
            nixpkgs.config = import ./config.nix;
          };
        };

      };

}
