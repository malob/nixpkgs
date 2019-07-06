self: super:
{
  kiwix-tools = super.pkgs.callPackage ../pkgs/kiwix-tools {};

  myLinuxEnv = self.buildEnv {
    name = "LinuxEnv";
    paths = with self.pkgs; [
      myCommonEnv
      kiwix-tools
      slack
      vscode
    ];
  };
}
