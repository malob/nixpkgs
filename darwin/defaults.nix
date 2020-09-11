{...}:

{
  # Module disabled because I'm using patched versions not yet upstreamed
  disabledModules = [
    "system/defaults/NSGlobalDomain.nix"
    "system/defaults/alf.nix"
    "system/defaults/finder.nix"
    "system/defaults/trackpad.nix"
    "system/defaults-write.nix"
  ];

  # Patched versions of disabled modules
  imports = [
    ./modules/system/defaults/NSGlobalDomain.nix
    ./modules/system/defaults/alf.nix
    ./modules/system/defaults/finder.nix
    ./modules/system/defaults/trackpad.nix
    ./modules/system/defaults-write.nix
  ];

  system.defaults.NSGlobalDomain = {
    "com.apple.trackpad.scaling"         = "3.0";
    AppleMeasurementUnits                = "Centimeters";
    AppleMetricUnits                     = true;
    AppleShowScrollBars                  = "Automatic";
    AppleTemperatureUnit                 = "Celsius";
    InitialKeyRepeat                     = 15;
    KeyRepeat                            = 2;
    NSAutomaticCapitalizationEnabled     = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
    _HIHideMenuBar                       = true;
  };

  # Firewall
  system.defaults.alf = {
    globalstate                = 1;
    allowsignedenabled         = true;
    allowdownloadsignedenabled = true;
    stealthenabled             = true;
  };

  # Dock and Mission Control
  system.defaults.dock = {
    autohide            = true;
    expose-group-by-app = false;
    mru-spaces          = false;
    tilesize            = 128;
  };

  # Login and lock screen
  system.defaults.loginwindow = {
    GuestEnabled         = false;
    DisableConsoleAccess = true;
  };

  # Spaces
  system.defaults.spaces.spans-displays = false;

  # Trackpad
  system.defaults.trackpad = {
    Clicking                = false;
    TrackpadRightClick      = true;
    AppleMultitouchTrackpad = 0;
  };

  # Finder
  system.defaults.finder = {
    ShowHardDrivesOnDesktop              = false;
    ShowExternalHardDrivesOnDesktop      = false;
    ShowRemovableMediaOnDesktop          = false;
    ShowMountedServersOnDesktop          = false;
    FXEnableExtensionChangeWarning       = true;
    FXEnableRemoveFromICloudDriveWarning = true;
    FXRemoveOldTrashItems                = true;
    WarnOnEmptyTrash                     = true;
    _FXSortFoldersFirst                  = true;
    _FXSortFoldersFirstOnDesktop         = true;
  };
}
