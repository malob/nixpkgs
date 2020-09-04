{ pkgs, ... }:

{

  ##############
  # Fish shell "
  ##############
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.fish.enable

  programs.fish.enable = true;

  # Functions
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.fish.functions
  programs.fish.functions = {
    # Change dir of term buffer in Neovim to match $PWD of shell
    nvim-term-change-dir = {
      body = ''
        if test -n "$NVIM_LISTEN_ADDRESS"
          ${pkgs.neovim-remote}/bin/nvr -c "lchd $PWD" -c "execute 'file term: $PWD [$fish_pid]'" -c "AirlineRefresh!" &
        end
      '';
      onEvent = "fish_prompt";
    };

    # Toggles between light and dark colors schemes for Kitty terminal, Neovim, and some CLI tools.
    toggle-colors = {
      body = let nvr = "${pkgs.neovim-remote}/bin/nvr"; in ''
        # Toggle envvar (default config on load is "dark")
        if test "$TERM_COLORS" = light
          set -xg TERM_COLORS dark
        else
          set -xg TERM_COLORS light
        end

        # If in Kitty terminal, toggle terminal colors
        if test -n "$KITTY_WINDOW_ID"
          kitty @ --to unix:/tmp/mykitty set-colors --all --configured ${pkgs.my-kitty-colors}/"$TERM_COLORS"-colors.conf
        end

        # If Neovim is running, use neovim-remote to sent command to toggle colors
        if test (${nvr} --serverlist)
          ${nvr} -s --nostart --servername (nvr --serverlist) -c "set background=$TERM_COLORS"
        end

        # Toggle colors that Bat and Delta use
        set -xg BAT_THEME ansi-"$TERM_COLORS"
      '';
    };
  };

  # Plugins
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.fish.plugins
  programs.fish.plugins = [
    {
      # Receive notifications when long processes finish
      # https://github.com/franciscolourenco/done
      name = "done";
      src  = (import ../nix/sources.nix).fish-plugin-done;
    }
    {
      # Dependency of Done plugin
      # https://github.com/fishpkg/fish-humanize-duration
      name = "humanize-duration";
      # We need to move the functions in a funcions dir for `programs.fish.plugins` to pick it up
      src = pkgs.linkFarm "humanize-duration"
        [ { name = "functions"; path = (import ../nix/sources.nix).fish-plugin-humanize-duration; } ];
    }
  ];

  # Aliases
  programs.fish.shellAliases = with pkgs; {
    ".." = "cd ..";
    cat  = "${bat}/bin/bat";
    du   = "${du-dust}/bin/dust";
    g    = "${gitAndTools.git}/bin/git";
    ls   = "${exa}/bin/exa";
    ll   = "ls -l --time-style long-iso --icons";
    la   = "ll -a";
    ps   = "${procs}/bin/procs";
  };

  # config.fish
  programs.fish.interactiveShellInit = with pkgs.neosolarized-colors; ''
    set -g fish_greeting ""
    set -g fish_term24bit 1
    nvim-term-change-dir
    thefuck --alias | source

    # Neovim Remote aliases
    # Taken from https://github.com/Soares/config.fish/blob/f9a8b48dd042bc93e62d4765633e41b119279040/config.fish#L18-L27
    # Not defined in `programs.fish.shellAliases` because of need to test for envvar
    if test -n "$NVIM_LISTEN_ADDRESS"
      alias nh "nvr -o"
      alias nv "nvr -O"
      alias nt "nvr --remote-tab"
      alias n  "nvr "
      alias neovim 'command nvim'
      alias nvim "echo 'You\'re already in nvim. Consider using n, h, v, or t instead. Use \'neovim\' to force.'"
    else
      alias n 'nvim'
    end

    # Colors for text in commands
    set -g fish_color_command ${base0} --bold  # color of commands
    set -g fish_color_param ${base0}           # color of regular command parameters
    set -g fish_color_autosuggestion ${base01} # color of autosuggestions
    set -g fish_color_comment ${base01}        # color of code comments
    set -g fish_color_error ${red}             # color of potential errors

    # Colors for special characters in commands
    set -g fish_color_escape ${base01}      # color of character escapes like '\n' and and '\x70'
    set -g fish_color_quote ${cyan}         # color of quoted blocks of text
    set -g fish_color_redirection ${violet} # color of IO redirections
    set -g fish_color_end ${blue}           # color of process separators like ';' and '&'
  '';


  ################
  # Shell prompt #
  ################

  programs.starship.enable = true;

  programs.starship.settings = {
    # See docs here: https://starship.rs/config/
    # Many symbols are taken from recomendations here:
    # https://starship.rs/presets/#nerd-font-symbols

    aws.symbol = " ";

    battery = {
      full_symbol        = "";
      charging_symbol    = "";
      discharging_symbol = "";
      display.threshold  = 25; # display battery information if charge is <= 25%
    };

    conda.symbol = " ";

    directory = {
      fish_style_pwd_dir_length = 1; # turn on fish directory truncation
      truncation_length         = 2; # number of directories not to truncate
    };

    docker.symbol = " ";

    elixir.symbol = " ";

    elm.symbol = " ";

    git_branch.symbol = " ";

    git_state = {
      rebase           = "咽";
      merge            = "";
      revert           = "";
      cherry_pick      = "";
      bisect           = "";
      am               = "ﯬ";
      am_or_rebase     = "ﯬ or 咽";
      progress_divider = " of ";
    };

    git_status = {
      prefix    = "";
      suffix    = " ";
      ahead     = " ";
      behind    = " ";
      diverged  = " ";
      untracked = " ";
      stashed   = " ";
      modified  = " ";
      staged    = " ";
      renamed   = " ";
      deleted   = " ";
    };

    golang.symbol = " ";

    haskell = {
      disabled = true; # too slow
      symbol   = " ";
    };

    hg_branch.symbol = " ";

    hostname.style = "bold green";

    java.symbol = " ";

    julia.symbol = " ";

    # Disable because it includes cached memory so memory is reported as full a lot
    memory_usage = {
      disabled  = true;
      symbol    = " ";
      threshold = 90;
    };

    nix_shell = {
      use_name = true;
      symbol = " ";
    };

    nodejs.symbol = " ";

    package.symbol = " ";

    php.symbol = " ";

    python.symbol = " ";

    ruby.symbol = " ";

    rust.symbol = " ";

    time = {
      disabled = true;
      format   = "%R";
    };

    username.style_user = "bold blue";
  };


  #########
  # Other #
  #########

  # Command history search (ctrl-r)
  # https://github.com/cantino/mcfly
  programs.mcfly.enable = true;
  programs.mcfly.keyScheme = "vim";

}
