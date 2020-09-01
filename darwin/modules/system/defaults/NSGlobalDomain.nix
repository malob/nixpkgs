{ config, lib, ... }:

with lib;

let
  isFloat = x: isString x && builtins.match "^[+-]?([0-9]*[.])?[0-9]+$" x != null;

  float = mkOptionType {
    name = "float";
    description = "float";
    check = isFloat;
    merge = options.mergeOneOption;
  };

in {
  options = {

    system.defaults.NSGlobalDomain.AppleFontSmoothing = mkOption {
      type = types.nullOr (types.enum [ 0 1 2 ]);
      default = null;
      example = 2;
      description = ''
        Sets the level of font smoothing (sub-pixel font rendering).
      '';
    };

    system.defaults.NSGlobalDomain.AppleKeyboardUIMode = mkOption {
      type = types.nullOr (types.enum [ 0 2 3 ]);
      default = null;
      example = "0 (macOS default)";
      description = ''
        # System Preferences > Keyboard > Shortcuts >
        Use keyboard natigation to move focus between controls

        Configures the keyboard behavior for tabbing between UI controls.

        Checkbox in System Preferences toggles between the values 0 and 2. Mode 3 enables full keyboard control.
      '';
    };

    system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "true (macOS default)";
      description = ''
        Whether to enable the press-and-hold key feature for typing characters with diacritics.
      '';
    };

    system.defaults.NSGlobalDomain.AppleShowAllExtensions = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "false (macOS default)";
      description = ''
        Whether to show all file extensions in finder.
      '';
    };

    system.defaults.NSGlobalDomain.AppleShowScrollBars = mkOption {
      type = types.nullOr (types.enum [ "Automatic" "WhenScrolling" "Always" ]);
      default = null;
      example = "\"Automatic\" (macOS default)";
      description = ''
        # System Preferences > General > Show scroll bars

        When to show the scrollbars.
      '';
    };

    system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "true (macOS default)";
      description = ''
        # System Preferences > Keyboard > Text > Capitalize words automatically

        Whether to enable automatic capitalization.
      '';
    };

    system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "true (macOS default)";
      description = ''
        # System Preferences > Keyboard > Text > Use smart quotes and dashes

        Whether to enable smart dash substitution.

        System Preferences checkbox sets both this option and NSAutomaticQuoteSubstitutionEnabled.
      '';
    };

    system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "true (macOS default)";
      description = ''
        # System Preferences > Keyboard > Text > Add period with double-space

        Whether to enable smart period substitution.
      '';
    };

    system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "true (macOS default)";
      description = ''
        # System Preferences > Keyboard > Text > Use smart quotes and dashes

        Whether to enable smart quote substitution.

        System Preferences checkbox sets both this option and NSAutomaticDashSubstitutionEnabled.
      '';
    };

    system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "true (macOS default)";
      description = ''
        # System Preferences > Keyboard > Text > Correct spelling automatically

        Whether to enable automatic spelling correction.
      '';
    };

    system.defaults.NSGlobalDomain.NSDisableAutomaticTermination = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "false (macOS default)";
      description = ''
        Whether to disable the automatic termination of inactive apps.
      '';
    };

    system.defaults.NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "true (macOS default)";
      description = ''
        Whether to save new documents to iCloud by default.
      '';
    };

    system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "false (macOS default)";
      description = ''
        Whether to use expanded save panel by default.
      '';
    };

    system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "false (macOS default)";
      description = ''
        Whether to use expanded save panel by default.
      '';
    };

    system.defaults.NSGlobalDomain.NSTableViewDefaultSizeMode = mkOption {
      type = types.nullOr (types.enum [ 1 2 3 ]);
      default = null;
      example = "3 (macOS default)";
      description = ''
        # System Preferences > General > Sidebar icon size

        Sets the size of the finder sidebar icons: 1 (Small), 2 (Medium) or 3 (Large).
      '';
    };

    system.defaults.NSGlobalDomain.NSTextShowsControlCharacters = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "false (macOS default)";
      description = ''
        Whether to display ASCII control characters using caret notation in standard text views.
      '';
    };

    system.defaults.NSGlobalDomain.NSUseAnimatedFocusRing = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "true (macOS default)";
      description = ''
        Whether to enable the focus ring animation.
      '';
    };

    system.defaults.NSGlobalDomain.NSScrollAnimationEnabled = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "true (macOS default)";
      description = ''
        Whether to enable smooth scrolling.
      '';
    };

    system.defaults.NSGlobalDomain.NSWindowResizeTime = mkOption {
      type = types.nullOr float;
      default = null;
      example = "0.20 (macOS default)";
      description = ''
        Sets the speed speed of window resizing.
      '';
    };

    system.defaults.NSGlobalDomain.InitialKeyRepeat = mkOption {
      type = types.nullOr types.int;
      default = null;
      example = 68;
      description = ''
        # System Preferences > Keyboard > Delay Unitl Repeat

        If you press and hold certain keyboard keys when in a text area, the key’s character begins
        to repeat. For example, the Delete key continues to remove text for as long as you hold it
        down. This sets how long you must hold down the key before it starts repeating.

        Slider in System Preferences sets the value bewteen 120 (Long) and 15 (Short).
      '';
    };

    system.defaults.NSGlobalDomain.KeyRepeat = mkOption {
      type = types.nullOr types.int;
      default = null;
      example = 30;
      description = ''
        # System Preferences > Keyboard > Key Repeat

        If you press and hold certain keyboard keys when in a text area, the key’s character begins
        to repeat. For example, the Delete key continues to remove text for as long as you hold it
        down. This sets how fast it repeats once it starts.

        Slider in System Preferences sets the value between 120 (Slow) and 2 (Fast). "Off" on the
        slider changes InitialKeyRepeat to 300000.
      '';
    };

    system.defaults.NSGlobalDomain.PMPrintingExpandedStateForPrint = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "false (macOS default)";
      description = ''
        Whether to use the expanded print panel by default.
      '';
    };

    system.defaults.NSGlobalDomain.PMPrintingExpandedStateForPrint2 = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "false (macOS default)";
      description = ''
        Whether to use the expanded print panel by default. The default is false.
      '';
    };

    system.defaults.NSGlobalDomain."com.apple.keyboard.fnState" = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        Use F1, F2, etc. keys as standard function keys.
      '';
    };

    system.defaults.NSGlobalDomain."com.apple.mouse.tapBehavior" = mkOption {
      type = types.nullOr (types.enum [ 1 ]);
      default = null;
      description = ''
        Configures the trackpad tap behavior. Mode 1 enables tap to click.
      '';
    };

    system.defaults.NSGlobalDomain."com.apple.sound.beep.volume" = mkOption {
      type = types.nullOr float;
      default = null;
      example = "1.0 (macOS default)";
      description = ''
        # System Preferences > Sound > Sound Effects > Alert volume

        Sets the beep/alert volume level from 0.0 (muted) to 1.0 (100% volume).

        75% = 0.7788008, 50% = 0.6065307, 25% = 0.4723665
      '';
    };

    system.defaults.NSGlobalDomain."com.apple.sound.beep.feedback" = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "1 (macOS default)";
      description = ''
        # System Preferences > Sound > Sound Effects > Play feedback when volume is changed

        Make a feedback sound when the system volume changed.
      '';
    };

    system.defaults.NSGlobalDomain."com.apple.trackpad.enableSecondaryClick" = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "true (macOS default)";
      description = ''
        Whether to enable trackpad secondary click.
      '';
    };

    system.defaults.NSGlobalDomain."com.apple.trackpad.trackpadCornerClickBehavior" = mkOption {
      type = types.nullOr (types.enum [ 1 ]);
      default = null;
      description = ''
        Configures the trackpad corner click behavior. Mode 1 enables right click.
      '';
    };

    system.defaults.NSGlobalDomain."com.apple.trackpad.scaling" = mkOption {
      type = types.nullOr float;
      default = null;
      example = "1.0 (macOS default)";
      description = ''
        # System Preferences > Trackpad > Point and Click > Tracking speed

        Configures the trackpad tracking speed.

        In System Preferences the slider sets the value between 0.0 (Slow) and 3.0 (Fast).
      '';
    };

    system.defaults.NSGlobalDomain."com.apple.springing.enabled" = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        Whether to enable spring loading (expose) for directories.
      '';
    };

    system.defaults.NSGlobalDomain."com.apple.springing.delay" = mkOption {
      type = types.nullOr float;
      default = null;
      example = "1.0 (macOS default)";
      description = ''
        Set the spring loading delay for directories.
      '';
    };

    system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "true (macOS default)";
      description = ''
        # System Preferences > Trackpad > Scroll and Zoom > Scroll direction: Natural

        Whether to enable "Natural" scrolling direction.
      '';
    };

    system.defaults.NSGlobalDomain.AppleMeasurementUnits = mkOption {
      type = types.nullOr (types.enum [ "Centimeters" "Inches" ]);
      default = null;
      example = "\"Centimeters\" (macOS default is based on region settings)";
      description = ''
        Whether to use centimeters (metric) or inches (US, UK) as the measurement unit.
      '';
    };

    system.defaults.NSGlobalDomain.AppleMetricUnits = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "true (macOS default is based on region settings)";
      description = ''
        Whether to use the metric system.
      '';
    };

    system.defaults.NSGlobalDomain.AppleTemperatureUnit = mkOption {
      type = types.nullOr (types.enum [ "Celsius" "Fahrenheit" ]);
      default = null;
      example = "\"Celsius\" (macOS default is based on region settings)";
      description = ''
        Whether to use Celsius or Fahrenheit for temperatures.
      '';
    };

    system.defaults.NSGlobalDomain._HIHideMenuBar = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "false (macOS default)";
      description = ''
        Whether to autohide the menu bar.
      '';
    };

  };

}
