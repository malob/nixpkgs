{ config, pkgs, lib, sources, ... }:

{
  # Fish Shell
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.fish.enable
  programs.fish.enable = true;

  # Fish plugins ------------------------------------------------------------------------------- {{{

  programs.fish.plugins = [
    {
      # Receive notifications when long processes finish
      # https://github.com/franciscolourenco/done
      name = "done";
      src = sources.fish-done;
    }
    {
      # Dependency of Done plugin
      # https://github.com/fishpkg/fish-humanize-duration
      name = "humanize-duration";
      # We need to move the functions in a "functions" dir for `programs.fish.plugins` to pick it up
      src = pkgs.linkFarm "humanize-duration"
        [ { name = "functions"; path = sources.fish-humanize-duration; } ];
    }
  ];
  # }}}

  # Fish functions ----------------------------------------------------------------------------- {{{

  programs.fish.functions = {
    # Toggles `$term_background` between "light" and "dark". Other Fish functions trigger when this
    # variable changes. We use a universal variable so that all instances of Fish have the same
    # value for the variable.
    toggle-background.body = ''
      if test "$term_background" = light
        set -U term_background dark
      else
        set -U term_background light
      end
    '';

    # Set `$term_background` based on whether macOS is light or dark mode. Other Fish functions
    # trigger when this variable changes. We use a universal variable so that all instances of Fish
    # have the same value for the variable.
    set-background-to-macOS.body = ''
      # Returns 'Dark' if in dark mode fails otherwise.
      if defaults read -g AppleInterfaceStyle 2>&1 /dev/null
        set -U term_background dark
      else
        set -U term_background light
      end
    '';

    # Sets Fish Shell to light or dark colorscheme based on `$term_background`.
    set-shell-colors = {
      body = ''
        # Toggle colors that Bat and Delta use
        set -xg BAT_THEME ansi-"$term_background"

        # Set color variables
        if test "$term_background" = light
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

        # Set Fish colors that change when background changes
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
      onVariable = "term_background";
    };
  };
  # }}}

  # Fish configuration ------------------------------------------------------------------------- {{{

  # Aliases
  programs.fish.shellAliases = with pkgs; {
    # Nix related
    drb = "darwin-rebuild build --flake ~/.config/nixpkgs/";
    drs = "env TERM=xterm-256color darwin-rebuild switch --flake ~/.config/nixpkgs/";
    #       ^ using `env` due to: https://github.com/nix-community/home-manager/issues/423
    flakeup = "nix flake update --recreate-lock-file ~/.config/nixpkgs/";

    # Other
    ".." = "cd ..";
    ":q" = "exit";
    cat = "${bat}/bin/bat";
    du = "${du-dust}/bin/dust";
    g = "${gitAndTools.git}/bin/git";
    la = "ll -a";
    ll = "ls -l --time-style long-iso --icons";
    ls = "${exa}/bin/exa";
    ps = "${procs}/bin/procs";
    tb = "toggle-background";
  };

  # Configuration that should be above `loginShellInit` and `interactiveShellInit`.
  programs.fish.shellInit = ''
    set -U fish_term24bit 1

    # Set `$term_background` based on whether macOS is in light or dark mode.
    set-background-to-macOS
  '';

  programs.fish.interactiveShellInit = ''
    set -g fish_greeting ""
    ${pkgs.thefuck}/bin/thefuck --alias | source

    # Run function to set colors that are dependant on `$term_background` and to register them so
    # they are triggerd when the relevent event happens or variable changes.
    set-shell-colors

    # Set Fish colors that aren't dependant the `$term_background`.
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
  '';
  # }}}

  # Starship Prompt
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.starship.enable
  programs.starship.enable = true;

  # Starship settings -------------------------------------------------------------------------- {{{

  programs.starship.settings = {
    # See docs here: https://starship.rs/config/
    # Many symbols are taken from recommendations here:
    # https://starship.rs/presets/#nerd-font-symbols

    aws.symbol = " ";

    battery = {
      full_symbol = "";
      charging_symbol = "";
      discharging_symbol = "";
      display.threshold = 25; # display battery information if charge is <= 25%
    };

    conda.symbol = " ";

    directory = {
      fish_style_pwd_dir_length = 1; # turn on fish directory truncation
      truncation_length = 2; # number of directories not to truncate
    };

    dart.symbol = " ";

    docker.symbol = " ";

    elixir.symbol = " ";

    elm.symbol = " ";

    gcloud.disabled = true;

    git_branch.symbol = " ";

    git_state = {
      rebase = "咽";
      merge = "";
      revert = "";
      cherry_pick = "";
      bisect = "";
      am = "ﯬ";
      am_or_rebase = "ﯬ or 咽";
      progress_divider = " of ";
    };

    git_status = {
      format = "([$all_status$ahead_behind]($style) )";
      conflicted = " ";
      ahead = " ";
      behind = " ";
      diverged = " ";
      untracked = " ";
      stashed = " ";
      modified = " ";
      staged = " ";
      renamed = " ";
      deleted = " ";
    };

    golang.symbol = " ";

    hg_branch.symbol = " ";

    hostname.style = "bold green";

    java.symbol = " ";

    julia.symbol = " ";

    # Disable because it includes cached memory so memory is reported as full a lot
    memory_usage = {
      disabled = true;
      symbol = " ";
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
      format = "%R";
    };

    username.style_user = "bold blue";
  };
  # }}}
}
# vim: foldmethod=marker
