{ lib, ... }:

let
  inherit (lib) mkOption types;
in

{
  options.users.primaryUser = {
    username = mkOption {
      type = with types; nullOr str;
      default = null;
    };
    fullName = mkOption {
      type = with types; nullOr str;
      default = null;
    };
    email = mkOption {
      type = with types; nullOr str;
      default = null;
    };
    nixConfigDirectory = mkOption {
      type = with types; nullOr str;
      default = null;
    };
  };
}
