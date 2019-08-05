self: super: {
  kiwix-tools = super.pkgs.callPackage ../pkgs/kiwix-tools {};

  myNixosEnv = self.buildEnv {
    name  = "NixosEnv";
    paths = with self.pkgs; [
      myCommonEnv
      kiwix-tools
      slack
      vscode
    ];
  };
}
