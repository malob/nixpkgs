self: super:
{
  hie = import (
    super.fetchFromGitHub {
      owner="domenkozar";
      repo="hie-nix";
      rev="3568848";
      sha256="00zs610p56l6afbizx2xbhc3wsr5v3fnwiwcs4hzk7myyzl2k4qc";
    }
  ) {};
}
