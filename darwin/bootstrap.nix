{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Nix configuration ------------------------------------------------------------------------------

  nix.settings = {
    substituters = [
      "https://cache.nixos.org/"
      "https://malo.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "malo.cachix.org-1:fJL4+lpyMs/1cdZ23nPQXArGj8AS7x9U67O8rMkkMIo="
    ];

    trusted-users = [ "@admin" ];

    # https://github.com/NixOS/nix/issues/7273
    auto-optimise-store = false;

    experimental-features = [
      "nix-command"
      "flakes"
    ];

    extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    # Recommended when using `direnv` etc.
    keep-derivations = true;
    keep-outputs = true;
  };

  nix.configureBuildUsers = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Shells -----------------------------------------------------------------------------------------

  # Add shells installed by nix to /etc/shells file
  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
  ];

  # Make Fish the default shell
  programs.fish.enable = true;
  programs.fish.useBabelfish = true;
  programs.fish.babelfishPackage = pkgs.babelfish;
  # Needed to address bug where $PATH is not properly set for fish:
  # https://github.com/LnL7/nix-darwin/issues/122
  programs.fish.shellInit = ''
    for p in (string split : ${config.environment.systemPath})
      if not contains $p $fish_user_paths
        set -g fish_user_paths $fish_user_paths $p
      end
    end
  '';
  environment.variables.SHELL = "${pkgs.fish}/bin/fish";

  # Install and setup ZSH to work with nix(-darwin) as well
  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
