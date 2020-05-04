self: super: {
  myPureScriptEnv = super.buildEnv {
    name  = "myPureScriptEnv";
    paths = with self.pkgs; [
      unstable.purescript
      unstable.spago
      myNodePackages.purescript-language-server
    ];
  };
}
