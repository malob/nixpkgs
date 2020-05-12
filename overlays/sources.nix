self: super:
let
  sources = import ../nix/sources.nix;
in {
  # Nixpkgs channels/branches
  stable   = import sources.nixpkgs-stable {};
  unstable = import sources.nixpkgs-unstable {};
  master   = import sources.nixpkgs-master {};

  # Other sources
  hies = import sources.hies {};
}
