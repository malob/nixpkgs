# Add stable, and master branches to package set, updated/managed via `niv`
self: super:
let
  sources = import ../nix/sources.nix;
in {
  # nixpkgs stable branch
  stable =
    if super.stdenv.isDarwin then
      import sources.nixpkgs-stable-darwin {}
    else
      import sources.nixos-stable {};
  # nixpkgs master branch
  master = import sources.nixpkgs-master {};
}
