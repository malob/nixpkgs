{ config, lib, ... }:

let
  inherit (lib) mkIf;
  caskPresent = cask: lib.any (x: x.name == cask) config.homebrew.casks;
  brewEnabled = config.homebrew.enable;
  brewShellInit = mkIf brewEnabled ''
    eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
  '';
in

{
  environment.shellInit = brewShellInit;
  programs.zsh.shellInit = brewShellInit; # `zsh` doesn't inherit `environment.shellInit`

  # https://docs.brew.sh/Shell-Completion#configuring-completions-in-fish
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
    "homebrew/core"
    "homebrew/services"
    "nrlquaker/createzap"
  ];

  # Prefer installing application from the Mac App Store
  homebrew.masApps = {
    "1Password for Safari" = 1569813296;
    Cardhop = 1290358394;
    DaisyDisk = 411643860;
    Fantastical = 975937182;
    Flighty = 1358823008;
    Hyperspace = 6739505345;
    "Kagi Search" = 1622835804;
    Keynote = 409183694;
    "Notion Web Clipper" = 1559269364;
    Numbers = 409203825;
    Pages = 409201541;
    Parcel = 639968404;
    Patterns = 429449079;
    "Pixelmator Pro" = 1289583905;
    "Playgrounds" = 1496833156;
    "Prime Video" = 545519333;
    SiteSucker = 442168834;
    Slack = 803453959;
    "Tailscale" = 1475387142;
    "Things 3" = 904280696;
    "WiFi Explorer" = 494803304;
    Xcode = 497799835;
    "Yubico Authenticator" = 1497506650;
  };

  # If an app isn't available in the Mac App Store, or the version in the App Store has
  # limitiations, e.g., Transmit, install the Homebrew Cask.
  homebrew.casks = [
    "1password"
    "anki"
    "arq"
    "autodesk-fusion"
    "balenaetcher"
    "bambu-studio"
    "betterdisplay"
    "chatgpt"
    "claude"
    "clay"
    "cleanmymac"
    "cursor"
    "discord"
    "docker"
    "element"
    "etrecheckpro"
    "firefox"
    "ghostty"
    "github-copilot-for-xcode"
    "google-chrome"
    "google-drive"
    "gpg-suite"
    # "keybase"
    "ledger-live"
    "loopback"
    "multiviewer-for-f1"
    "notion"
    "obsbot-center"
    "parallels"
    "pdf-expert"
    "postman"
    "protonvpn"
    "raycast"
    "signal"
    "sloth"
    "steam"
    "superhuman"
    "superlist"
    "tor-browser"
    "transmission"
    "transmit"
    "visual-studio-code"
    "vlc"
    "yubico-yubikey-manager"
    "zed"
  ];

  # Configuration related to casks
  home-manager.users.${config.users.primaryUser.username} =
    mkIf (caskPresent "1password" && config ? home-manager)
      {
        programs.ssh.enable = true;
        programs.ssh.extraConfig = ''
          # Only set `IdentityAgent` not connected remotely via SSH.
          # This allows using agent forwarding when connecting remotely.
          Match host * exec "test -z $SSH_TTY"
            IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
        '';
      };

  # Hack: https://github.com/ghostty-org/ghostty/discussions/2832
  environment.variables.XDG_DATA_DIRS = mkIf (caskPresent "ghostty") [
    "$GHOSTTY_SHELL_INTEGRATION_XDG_DIR"
  ];

  # For cli packages that aren't currently available for macOS in `nixpkgs`. Packages should be
  # installed in `../home/packages.nix` whenever possible.
  homebrew.brews = [
  ];
}
