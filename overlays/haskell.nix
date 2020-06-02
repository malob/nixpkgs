self: super: {
  myHaskellEnv = super.buildEnv {
    name  = "HaskellEnv";
    paths = with self.pkgs; [
      (hies.selection { selector = p: { inherit (p) ghc882 ghc865; }; })
      unstable.haskellPackages.hoogle
      unstable.haskellPackages.hpack
      unstable.stack
    ];
  };
}
