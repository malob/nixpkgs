{
  system ? builtins.currentSystem,
  config ? {},
  overlays ? (import ./default.nix).overlays
}:
  import (import ./default.nix).inputs.nixpkgs { inherit system config overlays;  }
