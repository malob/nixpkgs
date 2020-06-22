self: super:
let
  sources = import ../nix/sources.nix;
in {
  # Nixpkgs channels/branches
  stable =
    if super.stdenv.isDarwin then
      import sources.nixpkgs-stable-darwin {}
    else
      import sources.nixos-stable {};
  unstable =
    if super.stdenv.isDarwin then
      import sources.nixpkgs-unstable {}
    else
      import sources.nixos-unstable {};
  master = import sources.nixpkgs-master {};

  # Other sources
  hies = import sources.hies {};
  hls  = import sources.hls;
}
