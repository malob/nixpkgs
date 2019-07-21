self: super:
let
  # Make trivial gitconfig file that sources config file in this repo
  gitConfig = super.lib.generators.toINI {} {
    include = { path = "~/.config/nixpkgs/configs/git/config"; };
  };
in {
  # Wrap git to source minimal config specified above
  myGit = super.pkgs.symlinkJoin {
    name = "myGit";
    paths = [ super.pkgs.git ];
    buildInputs = [ super.pkgs.makeWrapper ];
    postBuild = ''
      mkdir -p "$out/.config/git"
      echo "${gitConfig}" > "$out/.config/git/config"
      wrapProgram $out/bin/git --set XDG_CONFIG_HOME "$out/.config"
    '';
  };

  myGitEnv = super.buildEnv {
    name  = "GitEnv";
    paths = with self.pkgs; [
      gitAndTools.diff-so-fancy
      gitAndTools.hub
      myGit
    ];
  };
}
