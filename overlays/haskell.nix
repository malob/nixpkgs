self: super:
let
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
in {
  myHaskellEnv = super.buildEnv {
    name  = "HaskellEnv";
    paths = with self.pkgs; [
      (all-hies.unstableFallback.selection { selector = p: { inherit (p) ghc882 ghc865; }; })
      unstable.haskellPackages.hoogle
      unstable.haskellPackages.hpack
      unstable.stack
    ];
  };
}
