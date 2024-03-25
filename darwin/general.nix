{ config, pkgs, lib, ... }:

{
  # Networking
  networking.dns = [
    "1.1.1.1"
    "8.8.8.8"
  ];

  # Apps
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [
    kitty
    terminal-notifier
  ];
  programs.nix-index.enable = true;

  # Fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
     recursive
     (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
   ];

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  # Garbage collection
  nix.gc.automatic = true;
  nix.gc.interval.Hour = 3;
  nix.gc.options = "--delete-older-than 15d";

  # Automate optimizing the store
  # Not using `nix.settings.auto-optimise-store` since it causes issues
  # https://github.com/NixOS/nix/issues/7273
  launchd.daemons.nix-optimise-store = {
    command = "${config.nix.package}/bin/nix store optimise";
    environment.NIX_REMOTE = lib.optionalString config.nix.useDaemon "daemon";
    serviceConfig.RunAtLoad = false;
    serviceConfig.StartCalendarInterval = [ { Hour = 4; } ];
  };
}
