{ config, lib, pkgs, ... }:

let
  inherit (lib) elem optionalString;
  inherit (config.home.user-info) nixConfigDirectory;
in

{
  # Fish Shell
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.fish.enable
  programs.fish.enable = true;

  # Add Fish plugins
  home.packages = [
    pkgs.fishPlugins.done
    pkgs.fishPlugins.github-copilot-cli-fish
  ];

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
      if defaults read -g AppleInterfaceStyle &>/dev/null
        set -U term_background dark
      else
        set -U term_background light
      end
    '';

    # Sets Fish Shell to light or dark colorscheme based on `$term_background`.
    set-shell-colors = {
      body = ''
        # Set LS_COLORS
        set -xg LS_COLORS (${pkgs.vivid}/bin/vivid generate solarized-$term_background)

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
      '' + optionalString config.programs.bat.enable ''

        # Use correct theme for `bat`.
        set -xg BAT_THEME "Solarized ($term_background)"
      '' + optionalString (elem pkgs.bottom config.home.packages) ''

        # Use correct theme for `btm`.
        if test "$term_background" = light
          alias btm "btm --color default-light"
        else
          alias btm "btm --color default"
        end
      '' + optionalString config.programs.neovim.enable ''

      # Set `background` of all running Neovim instances.
      for server in (${pkgs.neovim-remote}/bin/nvr --serverlist)
        ${pkgs.neovim-remote}/bin/nvr -s --nostart --servername $server \
          -c "set background=$term_background" &
      end
      '';
      onVariable = "term_background";
    };
  };
  # }}}

  # Fish configuration ------------------------------------------------------------------------- {{{

  # Aliases
  programs.fish.shellAliases = with pkgs; {
    # Nix related
    drb = "darwin-rebuild build --flake ${nixConfigDirectory}";
    drs = "darwin-rebuild switch --flake ${nixConfigDirectory}";
    flakeup = "nix flake update ${nixConfigDirectory}";
    nb = "nix build";
    nd = "nix develop";
    nf = "nix flake";
    nr = "nix run";
    ns = "nix search";

    # Other
    ".." = "cd ..";
    ":q" = "exit";
    cat = "${bat}/bin/bat";
    du = "${du-dust}/bin/dust";
    g = "${gitAndTools.git}/bin/git";
    la = "ll -a";
    ll = "ls -l --time-style long-iso --icons";
    ls = "${exa}/bin/exa";
    tb = "toggle-background";
  };

  # Configuration that should be above `loginShellInit` and `interactiveShellInit`.
  programs.fish.shellInit = ''
    set -U fish_term24bit 1
    ${optionalString pkgs.stdenv.isDarwin "set-background-to-macOS"}
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
}
# vim: foldmethod=marker
