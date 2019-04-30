self: super:
let
  gitConfig = super.lib.generators.toINI {} {
    user = {
      name  = "Malo Bourgon";
      email = "mbourgon@gmail.com";
    };
    pull.rebase = "true";
    alias = {
      # basic commands
      s   = "status";
      pu  = "push";
      puf = "push --force";
      pl  = "pull";
      d   = "diff";
      a   = "add";
      aa  = "add --all";
      # checkout commands
      co  = "checkout";
      cob = "checkout -b";
      com = "checkout master";
      # commit commands
      c     = "commit -m";
      ca    = "commit -a";
      cam   = "commit -a -m";
      amend = "commit --amend -m";
      # rebase commands
      rb   = "rebase";
      rbc  = "rebase --continue";
      rba  = "rebase --abort";
      # reset commands
      r      = "reset HEAD";
      r1     = "reset HEAD^";
      r2     = "reset HEAD^^";
      rhard  = "reset --hard";
      rhard1 = "reset HEAD^ --hard";
      rhard2 = "reset HEAD^^ --hard";
      # stash commands
      spu  = "stash push";
      spua = "stash push --all";
      spo  = "stack pop";
      # other commands
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
