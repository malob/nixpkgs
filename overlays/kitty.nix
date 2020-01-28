self: super:
let
  colors = import ../neo-solazired.nix;
  # https://sw.kovidgoyal.net/kitty/conf.html
  kittyConfig = with super.lib.generators; with colors;
    toKeyValue { mkKeyValue = mkKeyValueDefault {} " "; } {
      # Fonts
      font_family = if super.stdenv.isDarwin then
                      "JetBrainsMono Nerd Font Mono Regular"
                    else
                      "Fira Code Retina Nerd Font Complete";

      bold_font   = if super.stdenv.isDarwin then
                      "JetBrainsMono Nerd Font Mono Bold"
                    else
                      "Fira Code Bold Nerd Font Complete";

      italic_font = if super.stdenv.isDarwin then
                      "JetBrainsMono Nerd Font Mono Italic"
                    else
                      "Fira Code Light Nerd Font Complete";

      bold_italic_font = if super.stdenv.isDarwin then
                           "JetBrainsMono Nerd Font Mono Bold Italic"
                         else
                           "auto";

      font_size   = "13.0";

      # Cursor customization
      cursor            = "#${base0}";
      cursor_text_color = "#${base03}";

      # Window layout
      hide_window_decorations = "titlebar-only";

      # Tab bar
      tab_bar_edge            = "top";
      tab_bar_style           = "powerline";
      tab_title_template      = ''Tab {index}: {title}'';
      active_tab_foreground   = "#${base3}";
      active_tab_background   = "#${green}";
      active_tab_font_style   = "bold";
      inactive_tab_foreground = "#${base0}";
      inactive_tab_background = "#${base03}";
      inactive_tab_font_style = "normal";

      # Color scheme
      foreground = "#${base0}";
      background = "#${base03}";
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
  };
in {
  myKitty = super.pkgs.symlinkJoin rec {
    name        = "myKitty";
    paths       = [ self.pkgs.unstable.kitty ];
    buildInputs = [ super.pkgs.makeWrapper ];
    configPath  = "$out/.config/kitty";
    postBuild   = ''
      mkdir -p ${configPath}
      echo "${kittyConfig}" > ${configPath}/kitty.conf
      ${if super.stdenv.isDarwin then ''
      wrapProgram $out/Applications/kitty.app/Contents/MacOS/kitty --set KITTY_CONFIG_DIRECTORY ${configPath}
      '' else ''
      wrapProgram $out/bin/kitty --set KITTY_CONFIG_DIRECTORY ${configPath}
      ''}
    '';
  };
}
