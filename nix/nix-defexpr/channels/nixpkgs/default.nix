let
  sources = import ~/.config/nixpkgs/nix/sources.nix;
  pkgs    = import sources.nixpkgs-unstable {};
in
  if pkgs.stdenv.isDarwin then
    import sources.nixpkgs-staging
  else
    import sources.nixos-unstable
