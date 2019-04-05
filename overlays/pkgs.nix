self: super:
{
  pkgs = super.pkgs // { unstable = (import <nixos-unstable> {}); };
}
