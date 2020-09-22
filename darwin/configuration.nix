{ config, pkgs, lib, ... }:

{

  #######################
  # Modules and Imports #
  #######################

  # Module disabled because I'm using patched versions not yet upstreamed
  disabledModules = [
    "system/activation-scripts.nix"
  ];

  imports = [
    # nix-darwin module form home-manager
    # Can't just import `<home-manager/nix-darwin>` given that I use `niv` to manager channels
    "${(import <home-manager> {}).path}/nix-darwin"

    # Patched modules
    ./modules/system/activation-scripts.nix
    ./modules/security/pam.nix

    # Other nix-darwin configuration
    ./defaults.nix # options for macOS defaults (uses a bunch of patched modules)
    ./private.nix  # private settings not committed to git
    ./shells.nix   # shell configuration
  ];


  #####################
  # Nix configuration #
  #####################

  nix.nixPath = [
    { nixpkgs = "$HOME/.nix-defexpr/channels/nixpkgs"; }
  ];
  nix.binaryCaches = [
    "https://cache.nixos.org/"
    "https://iohk.cachix.org"
  ];
  nix.binaryCachePublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
  ];
  nix.trustedUsers = [
    "@admin"
  ];

  # Nixpkgs used config from user
  nixpkgs.config = import ../config.nix;
  # Hack to use user overlays with system configuration
  nixpkgs.overlays = map import ((import ../nix/lsnix.nix) ../overlays);

  # Enable experimental version of nix with flakes support
  nix.package      = pkgs.nixFlakes;
  nix.extraOptions = "experimental-features = nix-command flakes";

  # To change location use the following command after updating the option below
  # $ darwin-rebuild switch -I darwin-config=...
  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;


  ################
  # home-manager #
  ################

  # Use home-manager's nix-darwin module to manage configuration of tools etc.
  # https://rycee.gitlab.io/home-manager/index.html#sec-install-nix-darwin-module
  users.users.malo.home = "/Users/malo";
  home-manager.users.malo = import ../home-manager/configuration.nix;


  ########################
  # System configuration #
  ########################

  # Networking
  networking.dns = [
    "1.1.1.1"
    "8.8.8.8"
  ];
  networking.computerName = "Malo’s 💻";
  networking.hostName     = "MaloBookPro";
  networking.knownNetworkServices = [
    "Wi-Fi"
    "USB 10/100/1000 LAN"
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
  system.keyboard.enableKeyMapping      = true;
  system.keyboard.remapCapsLockToEscape = true;

  # Add ability to used TouchID for sudo authentication (custom module)
  security.pam.enableSudoTouchIdAuth = true;

  # Lorri daemon
  # Taken from: https://github.com/target/lorri/issues/96#issuecomment-579931485
  launchd.user.agents.lorri = {
    serviceConfig = {
      WorkingDirectory     = (builtins.getEnv "HOME");
      EnvironmentVariables = { };
      KeepAlive            = true;
      RunAtLoad            = true;
      StandardOutPath      = "/var/tmp/lorri.log";
      StandardErrorPath    = "/var/tmp/lorri.log";
    };
    script = ''
      source ${config.system.build.setEnvironment}
      exec ${pkgs.lorri}/bin/lorri daemon
    '';
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
