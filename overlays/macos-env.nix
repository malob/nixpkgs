self: super:
{
  myMacosEnv = self.buildEnv {
    name = "macOSEnv";
    paths = with self.pkgs; [
      myCommonEnv

      m-cli
      terminal-notifier
    ];
  };
}
