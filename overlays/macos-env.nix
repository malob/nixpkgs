self: super: {
  myMacosEnv = super.buildEnv {
    name = "macOSEnv";
    paths = with self.pkgs; [
      myCommonEnv

      m-cli
      terminal-notifier
      myGems.vimgolf

      # My custom nix related shell scripts
      nixuser-simlink-apps
      nix-update-darwin
    ];
  };
}
