{ config, pkgs, lib, ... }:

{
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
}
