{ config, pkgs, lib, ... }:

{
  # Module disabled beacause I'm using patched versions not yet upstreamed
  disabledModules = [
    "networking"
  ];

  imports = [
    # Patched modules
    ./modules/networking.nix

    # Other imports
    ./defaults.nix # options for macOS defaults (uses a bunch of patched modules)
    ./private.nix  # private settings not commited to git
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

  # Nixpkgs tweaks
  nixpkgs.config = import ../config.nix;
  # Hack to use user overlays with system configuration
  nixpkgs.overlays = map import ((import ./lsnix.nix) ../overlays);

  # Enable experimental version of nix with flakes support
  nix.package      = pkgs.unstable.nixFlakes;
  nix.extraOptions = "experimental-features = nix-command flakes";

  # To change location use the following command after updating the option below
  # $ darwin-rebuild switch -I darwin-config=...
  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  ########################
  # System configuration #
  ########################

  # Networking
  networking.dns = [
    "1.1.1.1"
    "8.8.8.8"
  ];
  networking.computerName = "Malo’s 💻"; # option not added upstream yet
  networking.hostName     = "MaloBookPro";
  networking.knownNetworkServices = [
    "Wi-Fi"
    "USB 10/100/1000 LAN"
  ];

  # Link some additional paths
  environment.pathsToLink = [
    "/etc/xdg"
  ];

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    # My standard set of packages to install
    myEnv

    # For idiosyncratic reasons I manages these seperatly for different OSs
    unstable.direnv
    unstable.lorri

    # macOS specific packages
    m-cli             # useful macOS cli commands
    prefmanager       # tool for working with macOS defaults
    terminal-notifier # notifications when terminal commands finish running
    myGems.vimgolf    # fun Vim puzzels
  ];
  programs.nix-index.enable = true;

  # Fonts
  fonts.enableFontDir = true;
  fonts.fonts = [
    (pkgs.unstable.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # Keyboard
  system.keyboard.enableKeyMapping      = true;
  system.keyboard.remapCapsLockToEscape = true;

  # Add ability to used TouchID for sudo authentication
  system.patches = [ ./etc-pam.d-sudo.patch ];

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
      exec ${pkgs.unstable.lorri}/bin/lorri daemon
    '';
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
