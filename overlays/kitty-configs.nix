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
  my-kitty-dark-config = with self.neosolarized-colors; rec {
    background = "#${base03}";
    foreground = "#${base0}";

    # Cursor
    cursor            = foreground;
    cursor_text_color = background;

    # Selection
    selection_background = "#${base01}";
    selection_foreground = background;

    # Intactive tab
    tab_bar_background = "#${base02}";
  };

  # Config for NeoSolarized light colors
  # https://sw.kovidgoyal.net/kitty/conf.html
  my-kitty-light-config = with self.neosolarized-colors; rec {
    background = "#${base3}";
    foreground = "#${base00}";

    # Cursor
    cursor            = foreground;
    cursor_text_color = background;

    # Selection
    selection_background = "#${base1}";
    selection_foreground = background;

    # Intactive tab
    tab_bar_background = "#${base2}";
  };

  # General kitty config (colors omitted)
  # https://sw.kovidgoyal.net/kitty/conf.html
  my-kitty-config = with self.neosolarized-colors; rec {
    # Required to use `kitty @` commands
    allow_remote_control = "yes";

    # Colors
    # black
    color0     = "#${base02}";
    color8     = "#${base03}";
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
    # url underline color to fit colors
    url_color = "#${blue}";

    # Fonts
    # Don't use Nerd Font version of fonts cause they often cause display issues in terminal,
    # instead, we patch the specific code-points in using `symbol_map`.
    # https://github.com/ryanoasis/nerd-fonts/wiki/Glyph-Sets-and-Code-Points
    font_family   = "Rec Mono Duotone";
    font_features = "RecMono-Duotone +dlig +ss10";
    symbol_map = "U+E5FA-U+E62B,U+E700-U+E7C5,U+F000-U+F2E0,U+E200-U+E2A9,U+F500-U+FD46,U+E300-U+E3EB,U+F400-U+F4A8,U+2665,U+26a1,U+F27C,U+E0A3,U+E0B4-U+E0C8,U+E0CA,U+E0CC-U+E0D2,U+E0D4,U+23FB-U+23FE,U+2B58,U+F300-U+F313,U+E000-U+E00D JetBrainsMono Nerd Font";
    font_size = "13.0";
    adjust_line_height = "120%";
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
  };

  # Write color configs to Nix store
  my-kitty-colors = super.pkgs.symlinkJoin {
    name        = "my-kitty-colors";
    paths       = [
      (writeKittyConfigToStore "dark-colors.conf" my-kitty-dark-config)
      (writeKittyConfigToStore "light-colors.conf" my-kitty-light-config)
    ];
  };
}
