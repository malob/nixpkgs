self: super: {
  myHaskellEnv = super.buildEnv {
    name  = "HaskellEnv";
    paths = with self.pkgs.unstable; [
      haskellPackages.haskell-language-server
      haskellPackages.hoogle
      haskellPackages.hpack
      haskellPackages.implicit-hie
      stack
    ];
  };
}
