{ config, lib, pkgs, ... }:
# Let-In --------------------------------------------------------------------------------------- {{{
let
  inherit (lib) mkIf;
  backgroundDependantColors = colors: with colors; {
    background = "#${base}";
    foreground = "#${main}";

    # Cursor
    cursor = "#${blue}";
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
    # https://fsd.it/shop/fonts/pragmatapro/
    font_family = "PragmataPro Mono Liga";
    font_size = "14.0";
    adjust_line_height = "140%";
    disable_ligatures = "cursor"; # disable ligatures when cursor is on them

    # Window layout
    hide_window_decorations = "titlebar-only";
    window_padding_width = "10";

    # Tab bar
    tab_bar_edge = "top";
    tab_bar_style = "powerline";
    tab_title_template = "Tab {index}: {title}";
    active_tab_font_style = "bold";
    inactive_tab_font_style = "normal";
    tab_activity_symbol = "";
  };

  # Change the style of italic font variants
  programs.kitty.extraConfig = ''
    font_features PragmataProMonoLiga-Italic +ss06
    font_features PragmataProMonoLiga-BoldItalic +ss07
  '';

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

  programs.fish.functions.set-term-colors = {
    body = "term-background $term_background";
    onVariable = "term_background";
  };
  programs.fish.interactiveShellInit = ''
    # Set term colors based on value of `$term_backdround` when shell starts up.
    set-term-colors
  '';
  # }}}
}
# vim: foldmethod=marker
