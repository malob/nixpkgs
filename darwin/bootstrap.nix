{
  lib,
  pkgs,
  ...
}:

{
  # Nix configuration -----------------------------------------------------------------------------

  # Let Determinate Nix manage the Nix installation
  nix.enable = false;

  # Nix settings for Determinate Nix
  # Note: experimental-features not needed (Determinate has flakes by default)
  determinate-nix.customSettings = {
    extra-substituters = "https://malo.cachix.org";
    extra-trusted-public-keys = "malo.cachix.org-1:fJL4+lpyMs/1cdZ23nPQXArGj8AS7x9U67O8rMkkMIo=";
    trusted-users = "@admin";
    extra-platforms = lib.optionalString (pkgs.stdenv.hostPlatform.system == "aarch64-darwin")
      "x86_64-darwin aarch64-darwin";
    # Recommended when using `direnv` etc.
    keep-derivations = "true";
    keep-outputs = "true";
  };

  # Shells ----------------------------------------------------------------------------------------

  # Add shells installed by nix to /etc/shells file
  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
  ];

  # Make Fish the default shell
  programs.fish.enable = true;
  programs.fish.useBabelfish = true;
  environment.variables.SHELL = "${pkgs.fish}/bin/fish";

  # Install and setup ZSH to work with nix(-darwin) as well
  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}
