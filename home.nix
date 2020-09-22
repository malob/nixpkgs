# Small home-manager config needed when not using home-manager as a module with nix-darwin or NixOS
{ config, pkgs, ... }:

{
  # Import main configuration
  imports = [
    ./home-manager/configuration.nix
    ./home-manager/linux.nix
  ];

  # Options that need to be set when using home-manager directly
  programs.home-manager.enable = true;
  programs.home-manager.path   = "${(import ./nix/sources.nix).home-manager}";
  # need to set path this way when using niv to manage channels

  home.username      = "malo";
  home.homeDirectory = "/home/malo";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";
}
