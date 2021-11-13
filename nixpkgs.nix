{
  system ? builtins.currentSystem,
  config ? {},
  overlays ? [],
}:
  import (import ./default.nix).inputs.nixpkgs-unstable { inherit system config overlays;  }
