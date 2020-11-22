# Add stable, and master branches to package set, updated/managed via `niv`
self: super:
let
  sources = import ../nix/sources.nix;
in
{
  # nixpkgs master branch
  master = import sources.nixpkgs-master {};

  # nixpkgs stable branch
  stable =
    if super.stdenv.isDarwin then
      import sources.nixpkgs-stable-darwin {}
    else
      import sources.nixos-stable {};

  # nixpkgs staging-next branch
  staging = import sources.nixpkgs-staging {};
}
