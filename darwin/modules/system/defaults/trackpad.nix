{ config, lib, ... }:

with lib;

{
  options = {

    system.defaults.trackpad.Clicking = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "false (macOS default)";
      description = ''
        # System Preferences > Trackpad > Point and Click > Tap to click

        Whether to enable trackpad tap to click.
      '';
    };

    system.defaults.trackpad.TrackpadRightClick = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "true (macOS default)";
      description = ''
        # System Preferences > Trackpad > Point and Click > Secondary click

        Whether to enable trackpad right click.
      '';
    };

    system.defaults.trackpad.TrackpadThreeFingerDrag = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "false (macOS default)";
      description = ''
        Whether to enable three finger drag.
      '';
    };

    system.defaults.trackpad.ActuationStrength = mkOption {
      type = types.nullOr (types.enum [ 0 1 ]);
      default = null;
      example = "1 (macOS default)";
      description = ''
        0 to enable Silent Clicking, 1 to disable.
      '';
    };

    system.defaults.trackpad.FirstClickThreshold = mkOption {
      type = types.nullOr (types.enum [ 0 1 2 ]);
      default = null;
      example = "1 (macOS default)";
      description = ''
        # System Preferences > Trackpad > Point and Click > Click

        0 for "Light", 1 for "Medium", 2 for "Firm".
      '';
    };

    system.defaults.trackpad.SecondClickThreshold = mkOption {
      type = types.nullOr (types.enum [ 0 1 2 ]);
      default = null;
      example = "1 (macOS default)";
      description = ''
        0 for "Light", 1 for "Medium", 2 for "Firm".
      '';
    };

    system.defaults.trackpad.AppleMultitouchTrackpad = mkOption {
      type = types.nullOr (types.enum [ 0 2 ]);
      default = null;
      example = "1 (macOS default)";
      description = ''
        # System Preferences > Trackpad > Point and Click > Click

        0 for "Light", 1 for "Medium", 2 for "Firm".
      '';
    };
  };
}
