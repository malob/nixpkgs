{ config, pkgs, lib, ... }:

{
  imports = [
    # Minimal config of Nix related options and shells
    ./bootstrap.nix

    # Other nix-darwin configuration
    ./homebrew.nix
    ./defaults.nix

    # Personal modules
    ./modules/security/pam.nix # pending upstream, PR #228
    ./modules/homebrew.nix # pending upstream, PR #262
  ] ++ lib.filter lib.pathExists [ ./private.nix ];

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
  fonts.enableFontDir = true;
  fonts.fonts = with pkgs; [
    recursive
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  # Add ability to used TouchID for sudo authentication (custom module)
  # Upstream PR: https://github.com/LnL7/nix-darwin/pull/228
  security.pam.enableSudoTouchIdAuth = true;
  system.activationScripts.extraActivation.text = config.system.activationScripts.pam.text;

  # Lorri daemon
  # https://github.com/target/lorri
  # Used in conjuction with Direnv which is installed in `../home-manager/configuration.nix`.
  services.lorri.enable = true;
}
