{
  system ? builtins.currentSystem,
  config ? {},
  overlays ? [],
  ...
}@args:
  import (import ./default.nix).inputs.nixpkgs-unstable args
