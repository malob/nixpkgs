self: super:
{
  pkgs = super.pkgs // { unstable = (import ~/.nix-defexpr/channels/unstable {}); };
}
