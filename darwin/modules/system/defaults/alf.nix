{ config, lib, ... }:

with lib;

{
  options = {
    system.defaults.alf.globalstate = mkOption {
      type = types.nullOr (types.enum [ 0 1 2 ]);
      default = null;
      example = "0 (macOS default)";
      description = ''
        # System Preferences > Security and Privacy > Firewall

        Enable the internal firewall to prevent unauthorised applications, programs
        and services from accepting incoming connections, where 0 is disabled, 1 is enabled, and 2
        corresponds to checking off "Block all incoming connections" in "Firewall Options...".
      '';
    };

    system.defaults.alf.allowsignedenabled = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "true (macOS default)";
      description = ''
        # System Preferences > Security and Privacy > Firewall > Firewall Options...

        Automatically allow built-in software to receive incoming connections.
      '';
    };

    system.defaults.alf.allowdownloadsignedenabled = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "true (macOS default)";
      description = ''
        # System Preferences > Security and Privacy > Firewall > Firewall Options...

        Automatically allow downloaded signed software to receive incoming connections.

        Allows software signed by a valid certificate authority to provide services accessed from
        the network.
      '';
    };

    system.defaults.alf.loggingenabled = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "true (macOS default)";
      description = ''
        Enable logging of requests made to the firewall.
      '';
    };

    system.defaults.alf.stealthenabled = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = "true (macOS default)";
      description = ''
        # System Preferences > Security and Privacy > Firewall > Firewall Options...

        Enable stealth mode.

        Don't respond to or acknowledge attempts to access this computer from the network by test
        applications using ICMP, such as Ping.
      '';
    };
  };
}
