{ config, pkgs, lib, ... }:

{
  #######################
  # Modules and Imports #
  #######################

  imports = [
    ./bootstrap.nix # setups up basic Nix/shell environment

    # Personal modules
    ./modules/security/pam.nix # pending upstream, PR #228
    ./modules/homebrew.nix # pending upstream, PR #262

    # Other nix-darwin configuration
    ./homebrew.nix
    ./defaults.nix # options for macOS defaults (uses a bunch of patched modules)
  ] ++ lib.filter lib.pathExists [ ./private.nix ];


  ########################
  # System configuration #
  ########################

  # Networking
  networking.dns = [
    "1.1.1.1"
    "8.8.8.8"
  ];

  # GUI apps (home-manager currently has issues adding them to ~/Applications)
  environment.systemPackages = with pkgs; [
    kitty
    terminal-notifier
  ];
  programs.nix-index.enable = true;

  # Fonts
  fonts.enableFontDir = true;
  fonts.fonts = with pkgs; [
    recursive
    jetbrains-mono
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  # Add ability to used TouchID for sudo authentication (custom module)
  security.pam.enableSudoTouchIdAuth = true;
  system.activationScripts.extraActivation.text = config.system.activationScripts.pam.text;

  # Lorri daemon
  services.lorri.enable = true;

  # Service to toggle term colors based on macOS
  # `AppleInterfaceStyle` is not defined when OS is in light mode, it's equal to "Dark" if the OS is
  # in dark mode.
  # launchd.user.agents.setTermColors = {
  #   path = [ pkgs.fish ];
  #   script = ''
  #     if defaults read -g AppleInterfaceStyle; then
  #       fish -c 'set -U term_colors dark'
  #     else
  #       fish -c 'set -U term_colors light'
  #     fi
  #   '';
  #   serviceConfig = {
  #     RunAtLoad = true;
  #     ProcessType = "Background";
  #     StartInterval = 30;
  #   };
  # };
}
