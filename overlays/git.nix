self: super:
let
  gitConfig = super.lib.generators.toINI {} {
    user = {
      name = "Malo Bourgon";
      email = "mbourgon@gmail.com";
    };
    pull.rebase = "true";
    alias = {
      s = "status";
      aa = "add --all";
      co = "checkout";
      cob = "checkout -b";
      c = "commit -m";
      ca = "commit -a";
      cam = "commit -a -m";
      amend = "commit --amend -m";
      pu = "push";
      pl = "pull";
      d = "diff";
      lg = "log --graph --abbrev-commit --decorate --format=format:'%C(blue)%h%C(reset) - %C(green)(%ar)%C(reset) %s %C(dim)- %an%C(reset)%C(yellow)%d%C(reset)' --all";
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
