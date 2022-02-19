{
  programs.git.aliases = {
    # Basic commands
    a = "add";
    aa = "add --all";
    d = "diff";
    dc = "diff --cached";
    pl = "pull";
    pu = "push";
    puf = "push --force";
    s = "status";

    # Checkout commands
    co = "checkout";
    cob = "checkout -b";
    com = "checkout master";

    # Commit commands
    amend = "commit --amend --no-edit";
    c = "commit";
    ca = "commit -a";
    cam = "commit -a -m";
    cm = "commit -m";

    # Rebase commands
    rb = "rebase";
    rba = "rebase --abort";
    rbc = "rebase --continue";
    rbi = "rebase --interactive";
    rbs = "rebase --skip";

    # Reset commands
    r = "reset HEAD";
    r1 = "reset HEAD^";
    r2 = "reset HEAD^^";
    rhard = "reset --hard";
    rhard1 = "reset HEAD^ --hard";
    rhard2 = "reset HEAD^^ --hard";

    # Stash commands
    sd = "stash drop";
    spo = "stash pop";
    spu = "stash push";
    spua = "stash push --all";

    # Other commands
    lg = "log --graph --abbrev-commit --decorate --format=format:'%C(blue)%h%C(reset) - %C(green)(%ar)%C(reset) %s %C(italic)- %an%C(reset)%C(magenta bold)%d%C(reset)' --all";
    rs = "restore --staged";
  };
}
