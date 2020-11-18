{ pkgs, ... }:

{

  ##############
  # Fish shell #
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
          ${pkgs.neovim-remote}/bin/nvr \
            -c "let g:term_pwds.$fish_pid = '$PWD'" \
            -c "call Set_term_pwd()"
        end
      '';
      onVariable = "PWD";
    };

    # Toggles `$term_colors` between "light" and "dark" (it's initially set in `interactiveShellInit`)
    toggle-colors = {
      body = ''
        # Toggle envvar (default set in `interactiveShellInit`)
        if test "$term_colors" = light
          set -U term_colors dark
        else
          set -U term_colors light
        end
      '';
    };

    # Changes colors of Kitty, Neovim, and some CLI tools when `$term_colors` changes
    terminal-colors = with pkgs.neosolarized-colors; {
      body = let nvr = "${pkgs.neovim-remote}/bin/nvr"; in ''
        # If in Kitty terminal, toggle terminal colors
        if test -n "$KITTY_WINDOW_ID"
          kitty @ --to $KITTY_LISTEN_ON set-colors --all --configured \
            ${pkgs.my-kitty-colors}/"$term_colors"-colors.conf &
        end

        # If Neovim is running, use neovim-remote to sent command to toggle colors
        if test (${nvr} --serverlist)
          ${nvr} -s --nostart --servername (nvr --serverlist) -c "set background=$term_colors" &
        end

        # Toggle colors that Bat and Delta use
        set -xg BAT_THEME ansi-"$term_colors"

        # Set Fish shell colors that depend on `$term_colors`
        if test "$term_colors" = light
          set emphasized_text  brgreen  # base01
          set normal_text      bryellow # base00
          set secondary_text   brcyan   # base1
          set background_light white    # base2
          set background       brwhite  # base3
        else
          set emphasized_text  brcyan   # base1
          set normal_text      brblue   # base0
          set secondary_text   brgreen  # base01
          set background_light black    # base02
          set background       brblack  # base03
        end

        set -g fish_color_command                    $emphasized_text --bold  # color of commands
        set -g fish_color_param                      $normal_text             # color of regular command parameters
        set -g fish_color_comment                    $secondary_text          # color of comments
        set -g fish_color_autosuggestion             $secondary_text          # color of autosuggestions
        set -g fish_pager_color_prefix               $emphasized_text --bold  # color of the pager prefix string
        set -g fish_pager_color_description          $selection_text          # color of the completion description
        set -g fish_pager_color_selected_prefix      $background
        set -g fish_pager_color_selected_completion  $background
        set -g fish_pager_color_selected_description $background

      '';
      onVariable = "term_colors";
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
    ":q" = "exit";
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
    nvim-term-change-dir
    thefuck --alias | source

    # Set terminal colors
    # the `terminal-colors` function sets certain colors based on the value of `$term_colors`, the
    # rest don't change and so a set afterwards.
    set -U fish_term24bit 1
    if test -z "$term_colors"
      set -U term_colors light # universal it always persists
    end
    terminal-colors
    set -g fish_color_quote        cyan      # color of commands
    set -g fish_color_redirection  brmagenta # color of IO redirections
    set -g fish_color_end          blue      # color of process separators like ';' and '&'
    set -g fish_color_error        red       # color of potential errors
    set -g fish_color_match        --reverse # color of highlighted matching parenthesis
    set -g fish_color_search_match --background=yellow
    set -g fish_color_selection    --reverse # color of selected text (vi mode)
    set -g fish_color_operator     green     # color of parameter expansion operators like '*' and '~'
    set -g fish_color_escape       red       # color of character escapes like '\n' and and '\x70'
    set -g fish_color_cancel       red       # color of the '^C' indicator on a canceled command

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

    dart.symbol = " ";

    docker.symbol = " ";

    elixir.symbol = " ";

    elm.symbol = " ";

    gcloud.disabled = true;

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
      format     = "([$all_status$ahead_behind]($style) )";
      conflicted = " ";
      ahead      = " ";
      behind     = " ";
      diverged   = " ";
      untracked  = " ";
      stashed    = " ";
      modified   = " ";
      staged     = " ";
      renamed    = " ";
      deleted    = " ";
    };

    golang.symbol = " ";

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

    nim.symbol = " ";

    nix_shell = {
      use_name = true;
      symbol = " ";
    };

    nodejs.symbol = " ";

    package.symbol = " ";

    perl.symbol = " ";

    php.symbol = " ";

    python.symbol = " ";

    ruby.symbol = " ";

    rust.symbol = " ";

    swift.symbol = "ﯣ ";

    time = {
      disabled = true;
      format   = "%R";
    };

    username.style_user = "bold blue";
  };

}
