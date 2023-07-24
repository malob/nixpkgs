{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf elem;
  caskPresent = cask: lib.any (x: x.name == cask) config.homebrew.casks;
  brewEnabled = config.homebrew.enable;
  homePackages = config.home-manager.users.${config.users.primaryUser.username}.home.packages;
in

{
  environment.shellInit = mkIf brewEnabled ''
    eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
  '';

  # https://docs.brew.sh/Shell-Completion#configuring-completions-in-fish
  # For some reason if the Fish completions are added at the end of `fish_complete_path` they don't
  # seem to work, but they do work if added at the start.
  programs.fish.interactiveShellInit = mkIf brewEnabled ''
    if test -d (brew --prefix)"/share/fish/completions"
      set -p fish_complete_path (brew --prefix)/share/fish/completions
    end

    if test -d (brew --prefix)"/share/fish/vendor_completions.d"
      set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end
  '';

  homebrew.enable = true;
  homebrew.onActivation.autoUpdate = true;
  homebrew.onActivation.cleanup = "zap";
  homebrew.global.brewfile = true;

  homebrew.taps = [
    "homebrew/cask"
    "homebrew/cask-drivers"
    "homebrew/cask-fonts"
    "homebrew/cask-versions"
    "homebrew/core"
    "homebrew/services"
    "nrlquaker/createzap"
  ];

  # Prefer installing application from the Mac App Store
  homebrew.masApps = {
    "1Password for Safari" = 1569813296;
    "Accelerate for Safari" = 1459809092;
    DaisyDisk = 411643860;
    "Dark Mode for Safari" = 1397180934;
    Deliveries = 290986013;
    Fantastical = 975937182;
    Flighty = 1358823008;
    Keynote = 409183694;
    "Notion Web Clipper" = 1559269364;
    Numbers = 409203825;
    Pages = 409201541;
    Patterns = 429449079;
    "Pixelmator Pro" = 1289583905;
    "Save to Raindrop.io" = 1549370672;
    Slack = 803453959;
    "Swift Playgrounds" = 1496833156;
    "Tailscale" = 1475387142;
    "Things 3" = 904280696;
    Vimari = 1480933944;
    "WiFi Explorer" = 494803304;
    # Re-enable when Xcode updates to version 15 in AppStore.
    # Xcode = 497799835;
    "Yubico Authenticator" = 1497506650;
  };

  # If an app isn't available in the Mac App Store, or the version in the App Store has
  # limitiations, e.g., Transmit, install the Homebrew Cask.
  homebrew.casks = [
    "1password"
    "1password-cli"
    "anki"
    "arq"
    "balenaetcher"
    "cleanmymac"
    "element"
    "etrecheckpro"
    "discord"
    "firefox"
    "google-chrome"
    "google-drive"
    "gpg-suite"
    "hammerspoon"
    "keybase"
    "ledger-live"
    "loopback"
    "mimestream"
    "multiviewer-for-f1"
    "notion"
    "nvidia-geforce-now"
    "obsbot-me-tool"
    "obsbot-webcam"
    "parallels"
    "postman"
    "protonvpn"
    "raindropio"
    "raycast"
    "signal"
    "skype"
    "sloth"
    "steam"
    "superhuman"
    "tor-browser"
    "transmission"
    "transmit"
    "visual-studio-code"
    "vlc"
    "yubico-yubikey-manager"
    "yubico-yubikey-personalization-gui"
  ];

  # Configuration related to casks
  home-manager.users.${config.users.primaryUser.username} =
    mkIf (caskPresent "1password-cli" && config ? home-manager) {
      programs.ssh.enable = true;
      programs.ssh.extraConfig = ''
        # Only set `IdentityAgent` not connected remotely via SSH.
        # This allows using agent forwarding when connecting remotely.
        Match host * exec "test -z $SSH_TTY"
          IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      '';
      home.shellAliases = {
        cahix = mkIf (elem pkgs.cachix homePackages) "op plugin run -- cachix";
        gh = mkIf (elem pkgs.gh homePackages) "op plugin run -- gh";
        nixpkgs-review = mkIf (elem pkgs.nixpkgs-review homePackages) "op run -- nixpkgs-review";
      };
      home.sessionVariables = {
        GITHUB_TOKEN = "op://Personal/GitHub Personal Access Token/credential";
      };
    };

  # For cli packages that aren't currently available for macOS in `nixpkgs`.Packages should be
  # installed in `../home/default.nix` whenever possible.
  homebrew.brews = [
    "swift-format"
    "swiftlint"
  ];
}
