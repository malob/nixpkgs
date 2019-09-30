self: super: {
  myLinuxEnv = self.buildEnv {
    name  = "LinuxEnv";
    paths = with self.pkgs; [
      myCommonEnv
    ];
  };
}
