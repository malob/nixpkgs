{
  # Use nerd font symbols preset as base
  programs.starship.extras.presets.nerd_font_symbols = true;

  programs.starship.settings = {
    # Git status symbols (not in preset)
    git_status.format = "([$all_status$ahead_behind]($style) )";
    git_status.ahead = " ";
    git_status.behind = " ";
    git_status.diverged = "󰹹 ";
    git_status.conflicted = "󰅰 ";
    git_status.untracked = " ";
    git_status.modified = " ";
    git_status.staged = " ";
    git_status.renamed = " ";
    git_status.deleted = " ";
    git_status.stashed = " ";

    # Overrides pending https://github.com/starship/starship/pull/7229
    aws.symbol = " ";
    azure.symbol = " ";
    cobol.symbol = " ";
    conda.symbol = " ";
    container.symbol = " ";
    dart.symbol = " ";
    direnv.symbol = " ";
    dotnet.symbol = " ";
    erlang.symbol = " ";
    gcloud.symbol = "󱇶 ";
    gleam.symbol = " ";
    helm.symbol = " ";
    java.symbol = " ";
    kubernetes.symbol = "󱃾 ";
    mojo.symbol = "󰈸 ";
    nats.symbol = " ";
    netns.symbol = "󰛳 ";
    nim.symbol = " ";
    odin.symbol = "󰟢 ";
    opa.symbol = " ";
    openstack.symbol = " ";
    pulumi.symbol = " ";
    purescript.symbol = " ";
    raku.symbol = "󱖊 ";
    red.symbol = "󱍼 ";
    shlvl.symbol = " ";
    singularity.symbol = " ";
    solidity.symbol = " ";
    spack.symbol = " ";
    sudo.symbol = " ";
    terraform.symbol = " ";
    typst.symbol = " ";
    vagrant.symbol = " ";
    vlang.symbol = " ";

    battery.unknown_symbol = "󰂑 ";
    os.symbols.AIX = " ";
    os.symbols.ALTLinux = " ";
    os.symbols.Bluefin = " ";
    os.symbols.Emscripten = " ";
    os.symbols.EndeavourOS = " ";
    os.symbols.Garuda = " ";
    os.symbols.Illumos = " ";
    os.symbols.InstantOS = " ";
    os.symbols.OpenBSD = " ";
    os.symbols.OpenCloudOS = " ";
    os.symbols.OracleLinux = "󰺡 ";
    os.symbols.PikaOS = " ";
    os.symbols.RedHatEnterprise = "󱄛 ";
    os.symbols.Redhat = "󱄛 ";
    os.symbols.Solus = " ";
    os.symbols.Ultramarine = " ";
    os.symbols.Uos = " ";
    os.symbols.openEuler = " ";
  };
}
