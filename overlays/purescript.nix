self: super: {
  myPureScriptEnv = super.buildEnv {
    name  = "myPureScriptEnv";
    paths = with self.pkgs; [
      unstable.nodePackages.bower
      unstable.purescript
      unstable.spago
      myNodePackages.purescript-language-server
    ];
  };
}
