# Colors from: https://ethanschoonover.com/solarized ----------------------------------------------

# SOLARIZED HEX     16/8 TERMCOL  XTERM/HEX   L*A*B      RGB         HSB
# --------- ------- ---- -------  ----------- ---------- ----------- -----------
# base03    #002b36  8/4 brblack  234 #1c1c1c 15 -12 -12   0  43  54 193 100  21
# base02    #073642  0/4 black    235 #262626 20 -12 -12   7  54  66 192  90  26
# base01    #586e75 10/7 brgreen  240 #585858 45 -07 -07  88 110 117 194  25  46
# base00    #657b83 11/7 bryellow 241 #626262 50 -07 -07 101 123 131 195  23  51
# base0     #839496 12/6 brblue   244 #808080 60 -06 -03 131 148 150 186  13  59
# base1     #93a1a1 14/4 brcyan   245 #8a8a8a 65 -05 -02 147 161 161 180   9  63
# base2     #eee8d5  7/7 white    254 #e4e4e4 92 -00  10 238 232 213  44  11  93
# base3     #fdf6e3 15/7 brwhite  230 #ffffd7 97  00  10 253 246 227  44  10  99
# yellow    #b58900  3/3 yellow   136 #af8700 60  10  65 181 137   0  45 100  71
# orange    #cb4b16  9/3 brred    166 #d75f00 50  50  55 203  75  22  18  89  80
# red       #dc322f  1/1 red      160 #d70000 50  65  45 220  50  47   1  79  86
# magenta   #d33682  5/5 magenta  125 #af005f 50  65 -05 211  54 130 331  74  83
# violet    #6c71c4 13/5 brmagenta 61 #5f5faf 50  15 -45 108 113 196 237  45  77
# blue      #268bd2  4/4 blue      33 #0087ff 55 -10 -45  38 139 210 205  82  82
# cyan      #2aa198  6/6 cyan      37 #00afaf 60 -35 -05  42 161 152 175  74  63
# green     #859900  2/2 green     64 #5f8700 60 -20  65 133 153   0  68 100  60

# Colors from: https://meat.io/oksolar ------------------------------------------------------------

# Name     OK Lightness   Chrome  Hue    Hex
# base03   27.4%          0.05    219.6  #002d38
# base02   32.1%          0.053   219.6  #093946
# base01   53.5%          0.029   219.6  #5b7279
# base00   54.4%          0.017   219.6  #657377
# base0    71.8%          0.017   198    #98a8a8
# base1    71.8%          0.03    198    #8faaab
# base2    93.4%          0.031   90     #f1e9d2
# base3    97.7%          0.012   90     #fbf7ef
# yellow   63.1%          0.129   86.4   #ac8300
# orange   63.1%          0.166   50.4   #d56500
# red      63.1%          0.221   21.6   #f23749
# magenta  63.1%          0.205   349.2  #dd459d
# violet   63.1%          0.121   280.8  #7d80d1
# blue     63.1%          0.141   244.8  #2b90d8
# cyan     63.1%          0.102   187.2  #259d94
# green    63.1%          0.148   118.8  #819500

{ config, ... }:

let
  commonLight = {
    namedColors = {
      # Solarized names
      base03 = "color8";
      base02 = "color0";
      base01 = "color10";
      base00 = "color11";
      base0 = "color12";
      base1 = "color14";
      base2 = "color7";
      base3 = "color15";
      yellow = "color3";
      orange = "color9";
      red = "color1";
      magenta = "color5";
      violet = "color13";
      blue = "color4";
      cyan = "color6";
      green = "color2";
    };

    terminal = {
      bg = "base3";
      fg = "base00";
      cursorBg = "blue";
      cursorFg = "base3";
      selectionBg = "#A9D2EF";
      selectionFg = "base00";
    };

    pkgThemes.kitty = {
      url_color = "blue";
      tab_bar_background = "base2";
      active_tab_background = "green";
      active_tab_foreground = "base3";
      inactive_tab_background = "base01";
      inactive_tab_foreground = "base3";
    };
  };

  commonDark = {
    inherit (commonLight) namedColors;

    terminal = {
      bg = "base03";
      fg = "base0";
      cursorBg = "blue";
      cursorFg = "base03";
      selectionBg = "#103956";
      selectionFg = "base0";
    };

    pkgThemes.kitty = {
      inherit (commonLight.pkgThemes.kitty)
        url_color
        active_tab_background
        active_tab_foreground
        inactive_tab_background
        ;

      tab_bar_background = "base02";
      inactive_tab_foreground = "base1";
    };
  };
in

{
  colors.solarized-light = {
    colors = {
      color0 = "#073642";
      color1 = "#dc322f";
      color2 = "#859900";
      color3 = "#b58900";
      color4 = "#268bd2";
      color5 = "#d33682";
      color6 = "#2aa198";
      color7 = "#eee8d5";
      color8 = "#002b36";
      color9 = "#cb4b16";
      color10 = "#586e75";
      color11 = "#657b83";
      color12 = "#839496";
      color13 = "#6c71c4";
      color14 = "#93a1a1";
      color15 = "#fdf6e3";
    };

    inherit (commonLight) namedColors terminal pkgThemes;
  };

  colors.solarized-dark = {
    inherit (config.colors.solarized-light) colors;

    inherit (commonDark) namedColors terminal pkgThemes;
  };

  colors.ok-solar-light = {
    colors = {
      color0 = "#093946";
      color1 = "#f23749";
      color2 = "#819500";
      color3 = "#ac8300";
      color4 = "#2b90d8";
      color5 = "#dd459d";
      color6 = "#259d94";
      color7 = "#f1e9d2";
      color8 = "#002d38";
      color9 = "#d56500";
      color10 = "#5b7279";
      color11 = "#657377";
      color12 = "#98a8a8";
      color13 = "#7d80d1";
      color14 = "#8faaab";
      color15 = "#fbf7ef";
    };

    inherit (commonLight) namedColors terminal pkgThemes;
  };

  colors.ok-solar-dark = {
    inherit (config.colors.ok-solar-light) colors;

    inherit (commonDark) namedColors terminal pkgThemes;
  };

  colors.malo-ok-solar-light = {
    colors = {
      color0 = "#093946";
      color1 = "#f23749";
      color2 = "#819500";
      color3 = "#ac8300";
      color4 = "#2b90d8";
      color5 = "#dd459d";
      color6 = "#259d94";
      color7 = "#ece9e0"; # changed chroma to 0.012 to match base3
      color8 = "#002d38";
      color9 = "#d56500";
      color10 = "#5b7279";
      color11 = "#657377";
      color12 = "#98a8a8";
      color13 = "#7d80d1";
      color14 = "#8faaab";
      color15 = "#fbf7ef";
    };

    inherit (commonLight) namedColors terminal pkgThemes;
  };

  colors.malo-ok-solar-dark = {
    inherit (config.colors.malo-ok-solar-light) colors;

    inherit (commonDark) namedColors terminal pkgThemes;
  };
}
