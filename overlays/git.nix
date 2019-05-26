self: super:
let
  colors = import ../neo-solazired.nix;
  # https://git-scm.com/docs/git-config
  gitConfig = with colors; super.lib.generators.toINI {} {
    user = {
      name  = "Malo Bourgon";
      email = "mbourgon@gmail.com";
    };
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
      cm    = "commit -m";
      ca    = "commit -a";
      cam   = "commit -a -m";
      amend = "commit --amend -m";
      # rebase commands
      rb   = "rebase";
      rba  = "rebase --abort";
      rbc  = "rebase --continue";
      rbi  = "rebase --interactive";
      rbs  = "rebase --skip";
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
      lg = ''log --graph --abbrev-commit --decorate --format=format:'%C(\"#${blue}\")%h%C(reset) - %C(\"#${green}\")(%ar)%C(reset) %s %C(italic)- %an%C(reset)%C(\"#${violet} bold\")%d%C(reset)' --all'';
    };
    "color.diff" = {
      meta       = ''\"#${base0} italic\"'';
      frag       = ''\"#${blue} bold\"'';
      func       = ''\"#${violet}\"'';
      commit     = ''\"#${yellow} bold\"'';
      old        = ''\"#${red} bold\"'';
      new        = ''\"#${green} bold\"'';
      whitespace = ''\"#${red} reverse\"'';
    };
    "color.diff-highlight" = {
      oldNormal    = ''\"#${red} bold\"'';
      oldHighlight = ''\"#${base03} bold #${red}\"'';
      newNormal    = ''\"#${green} bold\"'';
      newHighlight = ''\"#${base03} bold #${green}\"'';
    };
    core = {
      editor = "nvr --remote-wait-silent -cc split";
      pager  = "diff-so-fancy | less --tabs=2 -RFX --pattern '^(Date|added|deleted|modified): '";
    };
    pull.rebase = "true";
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
