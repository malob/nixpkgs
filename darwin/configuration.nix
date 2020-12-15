{ config, pkgs, lib, ... }:

{
  #######################
  # Modules and Imports #
  #######################

  imports = [
    # nix-darwin module form home-manager
    # Can't just import `<home-manager/nix-darwin>` given that I use `niv` to manager channels
    "${(import <home-manager> {}).path}/nix-darwin"

    # Personal modules
    ./modules/security/pam.nix # pending upstream, PR #228
    ./modules/programs/brew-bundle.nix # pending upstream, PR #262

    # Other nix-darwin configuration
    ./brew-bundle.nix
    ./defaults.nix # options for macOS defaults (uses a bunch of patched modules)
    ./shells.nix # shell configuration
  ] ++ lib.filter lib.pathExists [ ./private.nix ];


  #####################
  # Nix configuration #
  #####################

  nix.nixPath = [
    { nixpkgs = "$HOME/.nix-defexpr/channels/nixpkgs"; }
  ];
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
  # Hack to use user overlays with system configuration
  nixpkgs.overlays = map import ((import ../nix/lsnix.nix) ../overlays);

  # Enable experimental version of nix with flakes support
  nix.package = pkgs.nixFlakes;
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
  networking.hostName = "MaloBookPro";
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
  launchd.user.agents.setTermColors = {
    path = [ pkgs.fish ];
    script = ''
      if test -n $(defaults read -g AppleInterfaceStyle); then
        fish -c 'set -U term_colors dark'
      else
        fish -c 'set -U term_colors light'
      fi
    '';
    serviceConfig = {
      RunAtLoad = true;
      ProcessType = "Background";
      StartInterval = 30;
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
