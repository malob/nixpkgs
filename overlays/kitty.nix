self: super:
let
  # Import colors for colorscheme
  colors = import ../neo-solazired.nix;

  # Create a function to format Nix sets as Kitty config strings
  setToKittyConfig = with super.lib.generators;
    toKeyValue { mkKeyValue = mkKeyValueDefault {} " "; };

  # https://sw.kovidgoyal.net/kitty/conf.html
  kittyDarkColors = with colors; super.pkgs.writeText "kittyDarkColors.conf" (setToKittyConfig rec {
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
  });

  # https://sw.kovidgoyal.net/kitty/conf.html
  kittyLightColors = with colors; super.pkgs.writeText "kittyLightColors.conf" (setToKittyConfig rec {
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
  });

  # https://sw.kovidgoyal.net/kitty/conf.html
  kittyConfig = with colors; super.pkgs.writeText "kitty.conf" (setToKittyConfig rec {
    # Required to use `kitty @` commands
    allow_remote_control= "yes";

    # Include dark colors by default
    include = "${kittyDarkColors}";

    # Set default shell here so we don't need to to `chsh` on system
    shell = "${super.pkgs.unstable.fish}/bin/fish";

    # Fonts
    # TODO: transition Linux setup to use JetBrains Mono
    font_family      = if super.stdenv.isDarwin then
                         "JetBrainsMono Nerd Font Mono Regular"
                       else
                         "Fira Code Retina Nerd Font Complete";

    bold_font        = if super.stdenv.isDarwin then
                         "JetBrainsMonoExtraBold Nerd Font Mono Extra Bold"
                       else
                         "Fira Code Bold Nerd Font Complete";

    italic_font      = if super.stdenv.isDarwin then
                         "JetBrainsMono Nerd Font Mono Italic"
                       else
                         "Fira Code Light Nerd Font Complete";

    bold_italic_font = if super.stdenv.isDarwin then
                         "JetBrainsMonoExtraBold Nerd Font Mono Extra Bold Italic"
                       else
                         "auto";

    font_size = "13.0";
    disable_ligatures = "cursor"; # disable ligatures when cursor is on them

    # Window layout
    hide_window_decorations = "titlebar-only";

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
  });

in {
  myKitty = super.pkgs.symlinkJoin rec {
    name        = "myKitty";
    paths       = [ self.pkgs.unstable.kitty ];
    buildInputs = [ super.pkgs.makeWrapper ];
    configPath  = "$out/.config/kitty";
    kittyBin    = if super.stdenv.isDarwin then
                    "$out/Applications/kitty.app/Contents/MacOS/kitty"
                  else
                    "$out/bin/kitty";
    postBuild   = ''
      mkdir -p ${configPath}
      ln -s ${kittyConfig} ${configPath}/kitty.conf
      wrapProgram ${kittyBin} \
        --set KITTY_CONFIG_DIRECTORY ${configPath} \
        --add-flags "--listen-on unix:/tmp/mykitty"
    '';
  };

  term-colors = super.writeShellScriptBin "term-colors" ''
    CONFIG=""
    if [[ $1 == "dark" ]]; then
      CONFIG=${kittyDarkColors}
    elif [[ $1 == "light" ]]; then
      CONFIG=${kittyLightColors}
    else
      exit 1
    fi

    kitty @ --to unix:/tmp/mykitty set-colors --all --configured $CONFIG
    ${super.pkgs.neovim-remote}/bin/nvr \
      -s --nostart --servername $(nvr --serverlist) -c "set background=$1"
   '';

  terminal-colors-dark = super.writeShellScriptBin "term-dark" ''
    ${self.pkgs.term-colors}/bin/term-colors dark
  '';

  terminal-colors-light = super.writeShellScriptBin "term-light" ''
    ${self.pkgs.term-colors}/bin/term-colors light
  '';

  myKittyEnv = super.buildEnv {
    name  = "myKittyEnv";
    paths = with self.pkgs; [
      myKitty
      terminal-colors-dark
      terminal-colors-light
    ];
  };
}
