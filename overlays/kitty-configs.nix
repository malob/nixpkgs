# Used in home-manager Kitty terminal config: `../home-manager/configuration.nix`
# Used in home-manager Fish shell config: `../home-manager/shells.nix`
self: super:
let
  # Function to format Nix sets as Kitty config strings
  setToKittyConfig = with super.lib.generators;
    toKeyValue { mkKeyValue = mkKeyValueDefault {} " "; };

  # Funtion to write a Kitty configuration file into the store
  writeKittyConfigToStore = fileName: config:
    super.pkgs.writeTextDir "${fileName}" (setToKittyConfig config);

in rec {

  # Config for NeoSolarized dark colors
  # https://sw.kovidgoyal.net/kitty/conf.html
  my-kitty-neosolarized-dark-config = with self.neosolarized-colors; rec {
    # Colors
    # black
    color0     = "#${base03}";
    color8     = "#${base02}";
    # red
    color1     = "#${red}";
    color9     = "#${orange}";
    # green
    color2     = "#${green}";
    color10    = "#${base01}";
    # yellow
    color3     = "#${yellow}";
    color11    = "#${base00}";
    # blue
    color4     = "#${blue}";
    color12    = "#${base0}";
    # magenta
    color5     = "#${magenta}";
    color13    = "#${violet}";
    # cyan
    color6     = "#${cyan}";
    color14    = "#${base1}";
    # white
    color7     = "#${base2}";
    color15    = "#${base3}";

    background = color0;
    foreground = color12;

    # Cursor
    cursor            = foreground;
    cursor_text_color = background;

    # Selection
    selection_background = color10;
    selection_foreground = background;

    # Intactive tab
    tab_bar_background = color8;
  };

  # Config for NeoSolarized light colors
  # https://sw.kovidgoyal.net/kitty/conf.html
  my-kitty-neosolarized-light-config = with self.neosolarized-colors; rec {
    # Colors
    # black
    color0     = "#${base3}";
    color8     = "#${base2}";
    # red
    color1     = "#${red}";
    color9     = "#${orange}";
    # green
    color2     = "#${green}";
    color10    = "#${base1}";
    # yellow
    color3     = "#${yellow}";
    color11    = "#${base0}";
    # blue
    color4     = "#${blue}";
    color12    = "#${base00}";
    # magenta
    color5     = "#${magenta}";
    color13    = "#${violet}";
    # cyan
    color6     = "#${cyan}";
    color14    = "#${base01}";
    # white
    color7     = "#${base02}";
    color15    = "#${base03}";

    background = color0;
    foreground = color12;

    # Cursor
    cursor            = foreground;
    cursor_text_color = background;

    # Selection
    selection_background = color10;
    selection_foreground = background;

    # Intactive tab
    tab_bar_background = color8;
  };

  # General kitty config (colors omitted)
  # https://sw.kovidgoyal.net/kitty/conf.html
  my-kitty-config = with self.neosolarized-colors; rec {
    # Required to use `kitty @` commands
    allow_remote_control = "yes";

    # Fonts
    font_family      = "JetBrainsMono Nerd Font Medium";
    bold_font        = "JetBrainsMono Nerd Font Extra Bold";
    italic_font      = "JetBrainsMono Nerd Font Italic";
    bold_italic_font = "JetBrainsMono Nerd Font Extra Bold Italic";

    font_size = "13.0";
    adjust_line_height = "110%";
    disable_ligatures = "cursor"; # disable ligatures when cursor is on them

    # Window layout
    hide_window_decorations ="titlebar-only";
    window_padding_width = "10";

    # Tab bar
    tab_bar_edge            = "top";
    tab_bar_style           = "powerline";
    tab_title_template      = ''Tab {index}: {title}'';
    active_tab_foreground   = "#${base3}";
    active_tab_background   = "#${green}";
    active_tab_font_style   = "bold";
    inactive_tab_foreground = active_tab_foreground;
    inactive_tab_background = "#${base1}";
    inactive_tab_font_style = "normal";

    # Set url underline color to fit colors
    url_color = "#${blue}";
  };

  # Write color configs to Nix store
  my-kitty-colors = super.pkgs.symlinkJoin {
    name        = "my-kitty-colors";
    paths       = [
      (writeKittyConfigToStore "dark-colors.conf" my-kitty-neosolarized-dark-config)
      (writeKittyConfigToStore "light-colors.conf" my-kitty-neosolarized-light-config)
    ];
  };
}
