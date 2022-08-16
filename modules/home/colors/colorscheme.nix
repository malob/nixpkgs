{ name, config, lib, ... }:

let
  inherit (lib)
    attrNames
    attrValues
    hasPrefix
    listToAttrs
    literalExpression
    mapAttrs
    mkOption
    range
    types;

  baseColorOptions = listToAttrs (map
    (i: { name = "color${toString i}"; value = mkOption { type = types.str; }; })
    (range 0 15)
  );

  mkColorOption = args: mkOption (args // {
    type = types.enum (attrNames config.colors ++ attrValues config.colors ++ attrNames config.namedColors);
    apply = v: config.colors.${v} or config.namedColors.${v} or v;
  });

  kittyBaseColorOptions = listToAttrs (map
    (i: { name = "color${toString i}"; value = mkColorOption { default = "color${toString i}"; }; })
    (range 0 15)
  );

in

{
  options = {
    name = mkOption {
      type = types.str;
      default = name;
      defaultText = literalExpression "<name>";
    };

    colors = mkOption {
      type = types.submodule {
        options = baseColorOptions;
      };
    };

    namedColors = mkOption {
      type = types.attrsOf (types.enum (attrNames config.colors ++ attrValues config.colors));
      default = {};
      apply = mapAttrs (_: v: if hasPrefix "color" v then config.colors.${v} else v);
    };

    terminal = mkOption {
      type = types.submodule {
        options = {
          bg = mkColorOption {};
          fg = mkColorOption {};
          cursorBg = mkColorOption {};
          cursorFg = mkColorOption {};
          selectionBg = mkColorOption {};
          selectionFg = mkColorOption {};
        };
      };
    };

    pkgThemes.kitty = mkOption {
      type = types.submodule {
        options = kittyBaseColorOptions // {
          # Get defaults from `config.terminal`
          background = mkColorOption { default = config.terminal.bg; };
          foreground = mkColorOption { default = config.terminal.fg; };
          cursor = mkColorOption { default = config.terminal.cursorBg; };
          cursor_text_color = mkColorOption { default = config.terminal.cursorFg; };
          selection_background = mkColorOption { default = config.terminal.selectionBg; };
          selection_foreground = mkColorOption { default = config.terminal.selectionFg; };

          url_color = mkColorOption {};
          tab_bar_background = mkColorOption {};
          active_tab_background = mkColorOption {};
          active_tab_foreground = mkColorOption {};
          inactive_tab_foreground = mkColorOption {};
          inactive_tab_background = mkColorOption {};
        };
      };
    };
  };
}
