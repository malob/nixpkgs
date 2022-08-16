{ lib, ... }:

let
  inherit (lib) mkOption types;
in
{
  options = {
    colors = mkOption {
      default = {};
      type = types.attrsOf (types.submodule (import ./colorscheme.nix));
    };
  };
}
