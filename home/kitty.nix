{ config, lib, pkgs, ... }:
# Let-In --------------------------------------------------------------------------------------- {{{
let
  backgroundDependantColors = colors: with colors; {
    background = "#${base}";
    foreground = "#${main}";

    # Cursor
    cursor = "#${main}";
    cursor_text_color = "#${base}";

    # Selection
    selection_background = "#${muted}";
    selection_foreground = "#${base}";

    # Tab bar
    tab_bar_background = "#${basehl}";
    inactive_tab_background = "#${strong}";
  };
in
# }}}
{
  # Kitty terminal
  # https://sw.kovidgoyal.net/kitty/conf.html
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.kitty.enable
  programs.kitty.enable = true;

  # General config ----------------------------------------------------------------------------- {{{

  programs.kitty.settings = {
    # Fonts
    # Recursive: https://www.recursive.design
    # "Duotone" pre-configured version which uses Linear for normal text and Casual for italic
    # https://github.com/arrowtype/recursive/tree/main/fonts/ArrowType-Recursive-1.064/Recursive_Code
    font_family = "Rec Mono Duotone";
    font_features = "RecMono-Duotone +dlig +ss10";
    adjust_line_height = "120%";
    disable_ligatures = "cursor"; # disable ligatures when cursor is on them

    # Window layout
    hide_window_decorations = "titlebar-only";
    window_padding_width = "10";

    # Tab bar
    tab_bar_edge = "top";
    tab_bar_style = "powerline";
    tab_title_template = ''Tab {index}: {title}'';
    active_tab_font_style = "bold";
    inactive_tab_font_style = "normal";
    tab_activity_symbol = "";
  };

  programs.kitty.extras.useSymbolsFromNerdFont = "JetBrainsMono Nerd Font";
  # }}}

  # Colors config ------------------------------------------------------------------------------ {{{
  programs.kitty.extras.colors = with pkgs.lib.colors; {
    enable = true;

    # Colors that aren't dependent on background
    common = with pkgs.lib.colors.solarized.colors; {
      # black
      color0 = "#${darkBasehl}";
      color8 = "#${darkBase}";
      # red
      color1 = "#${red}";
      color9 = "#${orange}";
      # green
      color2 = "#${green}";
      color10 = "#${darkestTone}";
      # yellow
      color3 = "#${yellow}";
      color11 = "#${darkTone}";
      # blue
      color4 = "#${blue}";
      color12 = "#${lightTone}";
      # magenta
      color5 = "#${magenta}";
      color13 = "#${violet}";
      # cyan
      color6 = "#${cyan}";
      color14 = "#${lightestTone}";
      # white
      color7 = "#${lightBasehl}";
      color15 = "#${lightBase}";
      # url underline color to fit colors
      url_color = "#${blue}";
      # tab bar
      active_tab_foreground = "#${lightBase}";
      active_tab_background = "#${green}";
      inactive_tab_foreground = "#${lightBase}";
    };

    # Background dependent colors
    dark = backgroundDependantColors solarized.dark;
    light = backgroundDependantColors solarized.light;
  };

  programs.fish.functions.set-term-colors = lib.mkIf config.programs.kitty.enable {
    body = ''
      term-background $term_background
    '';
    onVariable = "term_background";
  };
  programs.fish.interactiveShellInit = lib.mkIf config.programs.kitty.enable ''
    # Set term colors based on value of `$term_backdround` when shell starts up.
    set-term-colors
  '';
  # }}}
}
# vim: foldmethod=marker
