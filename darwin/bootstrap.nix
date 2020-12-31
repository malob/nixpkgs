{ config, pkgs, lib, ... }:

{
  #####################
  # Nix configuration #
  #####################

  nix.binaryCaches = [
    "https://cache.nixos.org/"
    "https://iohk.cachix.org"
    "https://hydra.iohk.io"
    "https://malo.cachix.org"
  ];
  nix.binaryCachePublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    "malo.cachix.org-1:fJL4+lpyMs/1cdZ23nPQXArGj8AS7x9U67O8rMkkMIo="
  ];
  nix.trustedUsers = [
    "@admin"
  ];

  # Nixpkgs used config from user
  nixpkgs.config = import ../config.nix;

  # Enable experimental version of nix with flakes support
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = "experimental-features = nix-command flakes";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;


  ##########
  # Shells #
  ##########

  # Add shells installed by nix to /etc/shells file
  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
  ];

  # Make Fish the default shell
  programs.fish.enable = true;
  # Needed to address bug where $PATH is not properly set for fish:
  # https://github.com/LnL7/nix-darwin/issues/122
  programs.fish.interactiveShellInit = ''
    set -pg fish_function_path ${pkgs.fish-foreign-env}/share/fish-foreign-env/functions
    fenv source ${config.system.build.setEnvironment}
  '';
  # Needed to ensure Fish is set as the default shell:
  # https://github.com/LnL7/nix-darwin/issues/146
  environment.variables.SHELL = "/run/current-system/sw/bin/fish";

  # Install and setup ZSH to work with nix(-darwin) as well
  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
