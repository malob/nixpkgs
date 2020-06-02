self: super:
let
  gitConfig = super.pkgs.writeTextDir "git/config" ''
    [include]
      path = ~/.config/nixpkgs/configs/git/config
  '';
in {
  # Wrap Git so configs can be stored in ~/.config/nixpkgs
  myGit = super.pkgs.symlinkJoin rec {
    name        = "myGit";
    paths       = [ super.pkgs.git ];
    buildInputs = [ super.pkgs.makeWrapper ];
    postBuild   = "wrapProgram $out/bin/git --set XDG_CONFIG_HOME ${gitConfig}";
  };

  # Create env that includes other Git related stuff
  myGitEnv = super.buildEnv {
    name  = "myGitEnv";
    paths = with self.pkgs; [
      myGit
      unstable.gitAndTools.delta # make Git diffs nicer
      unstable.gitAndTools.gh    # GitHub's official CLI tool
      gitAndTools.hub            # Git wrapper that works adds a bunch of GitHub features
    ];
  };
}
