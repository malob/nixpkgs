self: super:
let
  gitConfig = super.lib.generators.toINI {} {
    user = {
      name = "Malo Bourgon";
      email = "mbourgon@gmail.com";
    };
  };
in {
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
}
