self: super: {
  myHaskellEnv = super.buildEnv {
    name  = "HaskellEnv";
    paths = with self.pkgs; [
      (hies.selection { selector = p: { inherit (p) ghc882 ghc865; }; })
      ((hls { version = "8.8.3"; }).exes.haskell-language-server)
      unstable.haskellPackages.hoogle
      unstable.haskellPackages.hpack
      unstable.stack
    ];
  };
}
