self: super: {
  # Wrap Git so configs can be stored in ~/.config/nixpkgs
  myGit = super.pkgs.symlinkJoin rec {
    name         = "myGit";
    paths        = [ super.pkgs.git ];
    buildInputs  = [ super.pkgs.makeWrapper ];
    userConfPath = "~/.config/nixpkgs/configs/git";
    gitConfig    = ''
      [include]
        path = ${userConfPath}/config
    '';
    postBuild   = ''
      mkdir -p "$out/.config/git"
      echo "${gitConfig}" > "$out/.config/git/config"
      wrapProgram $out/bin/git --set XDG_CONFIG_HOME "$out/.config"
    '';
  };

  # Create env that includes other Git related stuff
  myGitEnv = super.buildEnv {
    name  = "myGitEnv";
    paths = with self.pkgs; [
      myGit
      gitAndTools.diff-so-fancy # make Git diffs nicer
      gitAndTools.hub           # Git wrapper that works adds a bunch of GitHub features
    ];
  };
}
