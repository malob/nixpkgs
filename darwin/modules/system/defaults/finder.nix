{ config, lib, ... }:

with lib;

{
  options = {

    ################################
    # Finder Preferences > General #
    ################################

    system.defaults.finder.ShowExternalHardDrivesOnDesktop = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "true (macOS default)";
      description = ''
        # Finder Preferences > General > Show these items on the desktop > External disks

        Whether to show icons for external disks on the Desktop.

        (Note that this setting won't take effect until the Finder is restarted.)
      '';
    };

    system.defaults.finder.ShowHardDrivesOnDesktop = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "false (macOS default)";
      description = ''
        # Finder Preferences > General > Show these items on the desktop > Hard disks

        Whether to show icons for internal hard disks on the Desktop.

        (Note that this setting won't take effect until the Finder is restarted.)
      '';
    };

    system.defaults.finder.ShowMountedServersOnDesktop = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "false (macOS default)";
      description = ''
        # Finder Preferences > General > Show these items on the desktop > Connected servers

        Whether to show icons for connected servers on the Desktop.

        (Note that this setting won't take effect until the Finder is restarted.)
      '';
    };

    system.defaults.finder.ShowRemovableMediaOnDesktop = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "true (macOS default)";
      description = ''
        # Finder Preferences > General > Show these items on the desktop > CD's, DVD's and iPods

        Whether to show icons for removable media (e.g, CD's and iPods) on the Desktop.

        (Note that this setting won't take effect until the Finder is restarted.)
      '';
    };


    #################################
    # Finder Preferences > Advanced #
    #################################

    system.defaults.finder.FXEnableExtensionChangeWarning = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "true (macOS default)";
      description = ''
        # Finder Preferences > Advanced > Show warning before changing an extension

        Whether to show warnings before changing the file extension of files.

        (Note that this setting won't take effect until the Finder is restarted.)
      '';
    };

    system.defaults.finder.FXEnableRemoveFromICloudDriveWarning = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "true (macOS default)";
      description = ''
        # Finder Preferences > Advanced > Show warning before removing from iCloud Drive

        Whether to show warnings before removing files from iCloud Drive.

        (Note that this setting won't take effect until the Finder is restarted.)
      '';
    };

    system.defaults.finder.FXRemoveOldTrashItems = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "false (macOS default)";
      description = ''
        # Finder Preferences > Advanced > Remove items from Trash after 30 days

        Whether to show automatically files that have been in the Trash for 30 days.

        (Note that this setting won't take effect until the Finder is restarted.)
      '';
    };

    system.defaults.finder.WarnOnEmptyTrash = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "true (macOS default)";
      description = ''
        # Finder Preferences > Advanced > Show warning before emptying trash

        Whether to show warnings before emptying the Trash.
      '';
    };

    system.defaults.finder._FXSortFoldersFirst = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "false (macOS default)";
      description = ''
        # Finder Preferences > Advanced > Keep folders on top > In windows when sorting by name

        Whether to sort folders above files when sorting by name in Finder windows.
      '';
    };

    system.defaults.finder._FXSortFoldersFirstOnDesktop = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "false (macOS default)";
      description = ''
        # Finder Preferences > Advanced > Keep folders on top > On Desktop

        Whether to sort folders above files when sorting by name on the Desktop.
      '';
    };

    ###################
    # Hidden settings #
    ###################

    system.defaults.finder.AppleShowAllExtensions = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "false (macOS default)";
      description = ''
        Whether to always show file extensions.
      '';
    };

    system.defaults.finder.CreateDesktop = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "true (macOS default)";
      description = ''
        Whether to show icons on the desktop or not.
      '';
    };

    system.defaults.finder.QuitMenuItem = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "false (macOS default)";
      description = ''
        Whether to allow quitting of the Finder.
      '';
    };

    system.defaults.finder._FXShowPosixPathInTitle = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "false (macOS default)";
      description = ''
        Whether to show the full POSIX filepath in the window title.
      '';
    };

  };
}
