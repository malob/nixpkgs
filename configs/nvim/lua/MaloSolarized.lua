-- Solarized inspired colorscheme build in Lua with `lush.nvim`, according to my taste
-- Still early days, with lots of work needed
-- https://github.com/rktjmp/lush.nvim
--
-- Colorscheme file located in ../colors/MaloSolarized.vim
local lush = require 'lush'
local vim = vim
local hsl = lush.hsl

-- Helper function that chooses between two `lush.nvim` colors based on `vim.o.background`.
local function choose(dark, light) return vim.o.background == 'dark' and dark or light end

-- Init module
local M = {}

-- Setup core colors
M.colors = {
  darkBase     = hsl '#002b36', -- base03
  darkBaseHl   = hsl '#073642', -- base02
  darkestTone  = hsl '#586e75', -- base01
  darkTone     = hsl '#657b83', -- base00
  lightTone    = hsl '#839496', -- base0
  lightestTone = hsl '#93a1a1', -- base1
  lightBaseHl  = hsl '#eee8d5', -- base2
  lightBase    = hsl '#fdf6e3', -- base3
  yellow       = hsl '#b58900',
  orange       = hsl '#cb4b16',
  red          = hsl '#dc322f',
  magenta      = hsl '#d33682',
  violet       = hsl '#6c71c4',
  blue         = hsl '#268bd2',
  cyan         = hsl '#2aa198',
  green        = hsl '#859900',
}

-- Function to set/update colors that are dependant on `vim.o.background`
M.setBackgroundDependantColors = function ()
  M.colors.base      = choose(M.colors.darkBase     , M.colors.lightBase)
  M.colors.basehl    = choose(M.colors.darkBaseHl   , M.colors.lightBaseHl)
  M.colors.invbase   = choose(M.colors.lightBase    , M.colors.darkBase)
  M.colors.invbasehl = choose(M.colors.lightBaseHl  , M.colors.darkBaseHl)
  M.colors.main      = choose(M.colors.lightTone    , M.colors.darkTone)
  M.colors.faded     = choose(M.colors.darkTone     , M.colors.lightTone)
  M.colors.muted     = choose(M.colors.darkestTone  , M.colors.lightestTone)
  M.colors.strong    = choose(M.colors.lightestTone , M.colors.darkestTone)
end

-- Function that generates a parsed `lush.nvim` spec
-- I don't conform to the `lush.nvim` convention of having this module return the parsed spec
-- directly since I want the spec to change based on `vim.o.background`, and also want direct access
-- to the colors defined in this module.
--
-- Not that this means the `:Lushify` command won't work by default. When using that command the
-- return of this module should be changed from `return M` to `return M.getParsedLushSpec()`.
M.getParsedLushSpec = function ()

  -- Set/update colorscheme colors
  M.setBackgroundDependantColors()
  local c = M.colors

  -- Define the `lush.nvim` spec, parse it, then return it.
  -- Commented VimL code below is from the original `vim-colors-solarized` colorcheme for reference.
  return lush(function()
    return {
      -- Basic Highlights ---------------------------------------------------------------------- {{{

      -- exe "hi! Normal"         .s:fmt_none   .s:fg_base0  .s:bg_back
      Normal         { fg = c.main, bg = c.base },

      -- exe "hi! Comment"        .s:fmt_ital   .s:fg_base01 .s:bg_none
      Comment        { fg = c.muted, gui = 'italic' },

      -- Any constant
      -- exe "hi! Constant"       .s:fmt_none   .s:fg_cyan   .s:bg_none
      Constant       { fg = c.cyan },
      -- String         { }, -- a string constant: "this is a string"
      -- Character      { }, -- a character constant: 'c', '\n'
      -- Number         { }, -- a number constant: 234, 0xff
      -- Boolean        { }, -- a boolean constant: TRUE, false
      -- Float          { }, -- a floating point constant: 2.3e10

      -- Any variable name
      -- exe "hi! Identifier"     .s:fmt_none   .s:fg_blue   .s:bg_none
      Identifier     { fg = c.blue },
      -- Function       { }, -- function name (also: methods for classes)

      -- Any statement
      -- exe "hi! Statement"      .s:fmt_none   .s:fg_green  .s:bg_none
      Statement      { fg = c.green },
      -- Conditional    { }, -- if, then, else, endif, switch, etc.
      -- Repeat         { }, -- for, do, while, etc.
      -- Label          { }, -- case, default, etc.
      -- Operator       { }, -- "sizeof", "+", "*", etc.
      -- Keyword        { }, -- any other keyword
      -- Exception      { }, -- try, catch, throw

      -- Generic Preprocessor
      -- exe "hi! PreProc"        .s:fmt_none   .s:fg_orange .s:bg_none
      PreProc        { fg = c.orange },
      -- Include        { }, -- preprocessor #include
      -- Define         { }, -- preprocessor #define
      -- Macro          { }, -- same as Define
      -- PreCondit      { }, -- preprocessor #if, #else, #endif, etc.

      -- int, long, char, etc.
      -- exe "hi! Type"           .s:fmt_none   .s:fg_yellow .s:bg_none
      Type           { fg = c.yellow },
      -- StorageClass   { }, -- static, register, volatile, etc.
      -- Structure      { }, -- struct, union, enum, etc.
      -- Typedef        { }, -- A typedef

      -- Any special symbol
      -- exe "hi! Special"        .s:fmt_none   .s:fg_red    .s:bg_none
      Special        { fg = c.red },
      -- SpecialChar    { }, -- special character in a constant
      -- Tag            { }, -- you can use CTRL-] on this
      -- Delimiter      { }, -- character that needs attention
      -- SpecialComment { }, -- special things inside a comment
      -- Debug          { }, -- debugging statements

      -- Text that stands out, HTML links
      -- exe "hi! Underlined"     .s:fmt_none   .s:fg_violet .s:bg_none
      Underlined     { fg = c.violet },

      -- Left blank, hidden
      -- exe "hi! Ignore"         .s:fmt_none   .s:fg_none   .s:bg_none
      Ignore         {  },

      -- Any erroneous construct
      -- exe "hi! Error"          .s:fmt_bold   .s:fg_red    .s:bg_none
      Error          { fg = c.red, gui = 'bold' },

      -- Anything that needs extra attention; mostly the keywords TODO FIXME and XXX
      -- exe "hi! Todo"           .s:fmt_bold   .s:fg_magenta.s:bg_none
      Todo           { fg = c.magenta, gui = 'bold' },

      -- Not in Solarized
      Bold       { gui = 'bold' },
      Italic     { gui = 'italic' },

      --- }}}

      -- Neovim UI ----------------------------------------------------------------------------- {{{


      -- Cursors -----------------------------------------------------------------------------------

      -- Character under the cursor
      -- exe "hi! Cursor"         .s:fmt_none   .s:fg_base03 .s:bg_base0
      Cursor       { fg = c.base, bg = c.main },

      -- The character under the cursor when |language-mapping| is used (see 'guicursor').
      -- hi! link lCursor Cursor
      lCursor      { Cursor },

      -- Cursor in a focused terminal
      -- Not in Solarized
      TermCursor   { Cursor },

      -- Cursor in an unfocused terminal
      -- Not in Solarized
      TermCursorNC { Cursor },


      -- Search ------------------------------------------------------------------------------------

      -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
      -- exe "hi! IncSearch"      .s:fmt_stnd   .s:fg_orange .s:bg_none
      IncSearch { fg = c.orange, gui = 'standout' },

      -- Last search pattern highlighting (see 'hlsearch').
      -- Also used for similar items that need to stand out.
      -- exe "hi! Search"         .s:fmt_revr   .s:fg_yellow .s:bg_none
      Search    { fg = c.yellow, gui = 'reverse' },


      -- Selections --------------------------------------------------------------------------------

      -- Visual mode selection
      -- exe "hi! Visual"         .s:fmt_none   .s:fg_base01 .s:bg_base03 .s:fmt_revbb
      Visual    { fg = c.muted, bg = c.base, gui = 'reverse,bold'  },

      -- Visual mode selection when vim is "Not Owning the Selection".
      -- exe "hi! VisualNOS"      .s:fmt_stnd   .s:fg_none   .s:bg_base02 .s:fmt_revbb
      VisualNOS { bg = c.basehl, gui = 'standout,reverse,bold'  },


      -- Statusline --------------------------------------------------------------------------------

      -- Status line of current window.
      -- exe "hi! StatusLine"     .s:fmt_none   .s:fg_base1  .s:bg_base02 .s:fmt_revbb
      StatusLine   { fg = c.strong, bg = c.basehl, gui = 'reverse,bold' },

      -- Status lines of not-current windows. Note: if this is equal to "StatusLine" Vim will use
      -- "^^^" in the status line of the current window.
      -- exe "hi! StatusLineNC"   .s:fmt_none   .s:fg_base00 .s:bg_base02 .s:fmt_revbb
      StatusLineNC { StatusLine, fg = c.faded },


      -- Tabline -----------------------------------------------------------------------------------

      -- Not active tab page label.
      -- exe "hi! TabLine"        .s:fmt_undr   .s:fg_base0  .s:bg_base02  .s:sp_base0
      -- TabLine     { fg = c.main, bg = c.basehl, gui = 'underline', sp = c.main },
      TabLine     { fg = c.main, bg = c.basehl }, -- change

      -- Where there are no labels.
      -- exe "hi! TabLineFill"    .s:fmt_undr   .s:fg_base0  .s:bg_base02  .s:sp_base0
      TabLineFill { TabLine },

      -- Active tab page label.
      -- exe "hi! TabLineSel"     .s:fmt_undr   .s:fg_base01 .s:bg_base2   .s:sp_base0  .s:fmt_revbbu
      TabLineSel  { fg = c.muted, bg = c.invbasehl, gui = 'reverse,underline,bold', sp = c.main },


      -- Columns and other lines -------------------------------------------------------------------

      -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
      -- exe "hi! LineNr"         .s:fmt_none   .s:fg_base01 .s:bg_base02
      -- LineNr       { fg = c.main, bg = c.basehl },
      LineNr       { fg = c.muted, bg = c.base }, -- change

      -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
      -- Not in Solarized
      CursorLineNr { LineNr, fg = c.strong, gui = 'bold' },

      -- Column where |signs| are displayed.
      -- exe "hi! SignColumn"     .s:fmt_none   .s:fg_base0
      -- SignColumn   { fg = c.main },
      SignColumn   { fg = c.main, gui = 'bold' }, -- change

      -- Screen-column at the cursor, when 'cursorcolumn' is set.
      -- exe "hi! CursorColumn"   .s:fmt_none   .s:fg_none   .s:bg_base02
      CursorColumn { bg = c.basehl },

      -- Screen-line at the cursor, when 'cursorline' is set.
      -- Low-priority if foreground (ctermfg OR guifg) is not set.
      -- exe "hi! CursorLine"     .s:fmt_uopt   .s:fg_none   .s:bg_base02  .s:sp_base1
      CursorLine   { CursorColumn },

      -- Used for the columns set with 'colorcolumn'.
      -- exe "hi! ColorColumn"    .s:fmt_none   .s:fg_none   .s:bg_base02
      ColorColumn  { bg = c.basehl },

      -- The column separating vertically split windows.
      -- exe "hi! VertSplit"      .s:fmt_none   .s:fg_base00 .s:bg_base00
      -- VertSplit    { fg = c.faded, bg = c.faded },
      VertSplit    { fg = c.muted, gui = 'bold' }, -- change


      -- Folds -------------------------------------------------------------------------------------

      -- Line used for closed folds.
      -- exe "hi! Folded"         .s:fmt_undb   .s:fg_base0  .s:bg_base02  .s:sp_base03
      -- Folded     { fg = c.main, bg = c.basehl, gui = 'underline,bold', sp = c.base  },
      Folded     { fg = c.main, bg = c.basehl, gui = 'bold' }, -- change

      -- See 'foldcolumn'
      -- exe "hi! FoldColumn"     .s:fmt_none   .s:fg_base0  .s:bg_base02
      FoldColumn { fg = c.main, bg = c.basehl },


      -- Popup menu --------------------------------------------------------------------------------

      -- Normal item
      -- exe "hi! Pmenu"          .s:fmt_none   .s:fg_base0  .s:bg_base02  .s:fmt_revbb
      Pmenu      { fg = c.main, bg = c.basehl, gui = 'reverse,bold' },

      -- Selected item
      -- exe "hi! PmenuSel"       .s:fmt_none   .s:fg_base01 .s:bg_base2   .s:fmt_revbb
      PmenuSel   { fg = c.muted, bg = c.invbasehl, gui = 'reverse,bold' },

      -- Scrollbar
      -- exe "hi! PmenuSbar"      .s:fmt_none   .s:fg_base2  .s:bg_base0   .s:fmt_revbb
      PmenuSbar  { fg = c.invbasehl, bg = c.main, gui = 'reverse,bold' },

      -- Thumb of the scrollbar
      -- exe "hi! PmenuThumb"     .s:fmt_none   .s:fg_base0  .s:bg_base03  .s:fmt_revbb
      PmenuThumb { fg = c.main, bg = c.base, gui = 'reverse,bold' },


      -- Diff mode ---------------------------------------------------------------------------------

      -- Added line |diff.txt|
      -- exe "hi! DiffAdd"        .s:fmt_bold   .s:fg_green  .s:bg_base02 .s:sp_green
      DiffAdd    { fg = c.green, bg = c.basehl, gui = 'bold', sp = c.green },

      -- Changed line |diff.txt|
      -- exe "hi! DiffChange"     .s:fmt_bold   .s:fg_yellow .s:bg_base02 .s:sp_yellow
      DiffChange { fg = c.yellow, bg = c.basehl, gui = 'bold', sp = c.yellow },

      -- Deleted line |diff.txt|
      -- exe "hi! DiffDelete"     .s:fmt_bold   .s:fg_red    .s:bg_base02
      DiffDelete { fg = c.red, bg = c.basehl, gui = 'bold' },

      -- Changed text within a changed line |diff.txt|
      -- exe "hi! DiffText"       .s:fmt_bold   .s:fg_blue   .s:bg_base02 .s:sp_blue
      DiffText   { fg = c.blue, bg = c.basehl, gui = 'bold', sp = c.blue },


      -- Spell checker -----------------------------------------------------------------------------

      -- Word that is not recognized by the spellchecker. Combined with the highlighting used
      -- otherwise.
      -- exe "hi! SpellBad"       .s:fmt_curl   .s:fg_none   .s:bg_none    .s:sp_red
      SpellBad   { gui = 'undercurl', sp = c.red },


      -- Word that should start with a capital. Combined with the highlighting used otherwise.
      -- exe "hi! SpellCap"       .s:fmt_curl   .s:fg_none   .s:bg_none    .s:sp_violet
      SpellCap   { gui = 'undercurl', sp = c.violet },

      -- Word that is recognized by the spellchecker as one that is hardly ever used. Combined with
      -- the highlighting used otherwise.
      -- exe "hi! SpellRare"      .s:fmt_curl   .s:fg_none   .s:bg_none    .s:sp_cyan
      SpellRare  { gui = 'undercurl', sp = c.cyan },

      -- Word that is recognized by the spellchecker as one that is used in another region. Combined
      -- with the highlighting used otherwise.
      -- exe "hi! SpellLocal"     .s:fmt_curl   .s:fg_none   .s:bg_none    .s:sp_yellow
      SpellLocal { gui = 'undercurl', sp = c.yellow },


      -- Messages, prompts, etc. -------------------------------------------------------------------

      -- Error messages on the command line
      -- exe "hi! ErrorMsg"       .s:fmt_revr   .s:fg_red    .s:bg_none
      ErrorMsg   { fg = c.red, gui = 'reverse' },

      -- Warning messages
      -- exe "hi! WarningMsg"     .s:fmt_bold   .s:fg_red    .s:bg_none
      WarningMsg { fg = c.red, gui = 'bold' },

      -- 'showmode' message (e.g., "-- INSERT -- ")
      -- exe "hi! ModeMsg"        .s:fmt_none   .s:fg_blue   .s:bg_none
      ModeMsg    { fg = c.blue },

      -- |more-prompt|
      -- exe "hi! MoreMsg"        .s:fmt_none   .s:fg_blue   .s:bg_none
      MoreMsg    { fg = c.blue },

      -- Directory names (and other special names in listings)
      -- exe "hi! Directory"      .s:fmt_none   .s:fg_blue   .s:bg_none
      Directory  { fg = c.blue },

      -- |hit-enter| prompt and yes/no questions
      -- exe "hi! Question"       .s:fmt_bold   .s:fg_cyan   .s:bg_none
      Question   { fg = c.cyan, gui = 'bold' },

      -- Titles for output from ":set all", ":autocmd" etc.
      -- exe "hi! Title"          .s:fmt_bold   .s:fg_orange .s:bg_none
      Title      { fg = c.orange, gui = 'bold' },


      -- Other character highlights ----------------------------------------------------------------

      -- Placeholder characters substituted for concealed text (see 'conceallevel')
      -- exe "hi! Conceal"        .s:fmt_none   .s:fg_blue   .s:bg_none
      Conceal    { fg = c.blue },

      -- The character under the cursor or just before it, if it is a paired bracket,
      -- and its match. |pi_paren.txt|
      -- exe "hi! MatchParen"     .s:fmt_bold   .s:fg_red    .s:bg_base01

      MatchParen { fg = c.red, bg = c.muted, gui = 'bold' },
      --
      -- Unprintable characters: text displayed differently from what it really is.
      -- exe "hi! SpecialKey" .s:fmt_bold   .s:fg_base00 .s:bg_base02
      SpecialKey { fg = c.faded, bg = c.basehl, gui = 'bold' },

      -- '@' at the end of the window, characters from 'showbreak' and other characters that do not
      -- really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at
      -- the end of the line). See also |hl-EndOfBuffer|.
      -- exe "hi! NonText"    .s:fmt_bold   .s:fg_base00 .s:bg_none
      NonText    { fg = c.faded, gui = 'bold' },

      -- Current match in 'wildmenu' completion
      -- exe "hi! WildMenu"       .s:fmt_none   .s:fg_base2  .s:bg_base02 .s:fmt_revbb
      WildMenu   { fg = c.invbasehl, bg = c.basehl, gui = 'reverse,bold' },

      --- }}}

      -- TODO: Not in Solarized ---------------------------------------------------------------- {{{

      -- EndOfBuffer  { }, -- filler lines (~) after the end of the buffer.  By default, this is highlighted like |hl-NonText|.
      -- QuickFixLine { }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
      -- MsgArea      { }, -- area for messages and cmdline
      -- MsgSeparator { }, -- Separator for scrolled messages, `msgsep` flag of 'display'
      -- NormalNC     { Normal }, -- normal text in non-current windows
      NormalFloat  { Normal, bg = c.basehl }, -- Normal text in floating windows.
      -- Sustitute   { }, -- |:substitute| replacement text highlighting
      -- Whitespace   { }, -- "nbsp", "space", "tab" and "trail" in 'listchars'

      -- }}}

      -- TODO: LSP ----------------------------------------------------------------------------- {{{

      -- These groups are for the native LSP client. Some other LSP clients may use these groups,
      -- or use their own. Consult your LSP client's documentation.

      LspDiagnosticsDefaultError            { fg = c.red },
      -- LspDiagnosticsVirtualTextError       { }, -- used for "Error" diagnostic virtual text.
      -- LspDiagnosticsFloatingError          { }, -- used for "Error" diagnostic messages in the diagnostics float
      -- LspDiagnosticsSignError              { }, -- used for "Error" diagnostic signs in sign column
      LspDiagnosticsDefaultWarning          { fg = c.yellow },
      -- LspDiagnosticsVirtualTextWarning     { }, -- used for "Warning" diagnostic virtual text.
      -- LspDiagnosticsFloatingWarning        { }, -- used for "Warning" diagnostic messages in the diagnostics float
      -- LspDiagnosticsSignWarning            { }, -- used for "Warning" diagnostic signs in sign column
      LspDiagnosticsDefaultInformation      { fg = c.main },
      -- LspDiagnosticsVirtualTextInformation { }, -- used for "Information" diagnostic virtual text.
      -- LspDiagnosticsFloatingInformation    { }, -- used for "Information" diagnostic messages in the diagnostics float
      -- LspDiagnosticsSignInformation        { }, -- used for "Information" signs in sign column
      LspDiagnosticsDefaultHint             { fg = c.muted },
      -- LspDiagnosticsVirtualTextHint        { }, -- used for "Hint" diagnostic virtual text.
      -- LspDiagnosticsFloatingHint           { }, -- used for "Hint" diagnostic messages in the diagnostics float
      -- LspDiagnosticsSignHint               { }, -- used for "Hint" diagnostic signs in sign column

      LspDiagnosticsUnderlineError         { gui = 'undercurl', guisp = c.red }, -- used to underline "Error" diagnostics.
      LspDiagnosticsUnderlineWarning       { gui = 'undercurl', guisp = c.yellow }, -- used to underline "Warning" diagnostics.
      LspDiagnosticsUnderlineInformation   { gui = 'undercurl', guisp = c.strong }, -- used to underline "Information" diagnostics.
      LspDiagnosticsUnderlineHint          { gui = 'undercurl', guisp = c.strong }, -- used to underline "Hint" diagnostics.

      -- LspReferenceText                  { }, -- used for highlighting "text" references
      -- LspReferenceRead                  { }, -- used for highlighting "read" references
      -- LspReferenceWrite                 { }, -- used for highlighting "write" references

      -- }}}

      -- TODO: TreeSitter ---------------------------------------------------------------------- {{{

      -- These groups are for the neovim tree-sitter highlights. As of writing, tree-sitter support
      -- is a WIP, group names may change. By default, most of these groups link to an appropriate
      -- Vim group, TSError -> Error for example, so you do not have to define these unless you
      -- explicitly want to support Treesitter's improved syntax awareness.

      -- TSError              { }, -- For syntax/parser errors.
      -- TSPunctDelimiter     { }, -- For delimiters ie: `.`
      -- TSPunctBracket       { }, -- For brackets and parens.
      -- TSPunctSpecial       { }, -- For special punctutation that does not fall in the catagories before.
      -- TSConstant           { }, -- For constants
      -- TSConstBuiltin       { }, -- For constant that are built in the language: `nil` in Lua.
      -- TSConstMacro         { }, -- For constants that are defined by macros: `NULL` in C.
      -- TSString             { }, -- For strings.
      -- TSStringRegex        { }, -- For regexes.
      -- TSStringEscape       { }, -- For escape characters within a string.
      -- TSCharacter          { }, -- For characters.
      -- TSNumber             { }, -- For integers.
      -- TSBoolean            { }, -- For booleans.
      -- TSFloat              { }, -- For floats.
      -- TSFunction           { }, -- For function (calls and definitions).
      -- TSFuncBuiltin        { }, -- For builtin functions: `table.insert` in Lua.
      -- TSFuncMacro          { }, -- For macro defined fuctions (calls and definitions): each `macro_rules` in Rust.
      -- TSParameter          { }, -- For parameters of a function.
      -- TSParameterReference { }, -- For references to parameters of a function.
      -- TSMethod             { }, -- For method calls and definitions.
      -- TSField              { }, -- For fields.
      -- TSProperty           { }, -- Same as `TSField`.
      -- TSConstructor        { }, -- For constructor calls and definitions: `{ }` in Lua, and Java constructors.
      -- TSConditional        { }, -- For keywords related to conditionnals.
      -- TSRepeat             { }, -- For keywords related to loops.
      -- TSLabel              { }, -- For labels: `label:` in C and `:label:` in Lua.
      -- TSOperator           { }, -- For any operator: `+`, but also `->` and `*` in C.
      -- TSKeyword            { }, -- For keywords that don't fall in previous categories.
      -- TSKeywordFunction    { }, -- For keywords used to define a fuction.
      -- TSException          { }, -- For exception related keywords.
      -- TSType               { }, -- For types.
      -- TSTypeBuiltin        { }, -- For builtin types (you guessed it, right ?).
      -- TSNamespace          { }, -- For identifiers referring to modules and namespaces.
      -- TSInclude            { }, -- For includes: `#include` in C, `use` or `extern crate` in Rust, or `require` in Lua.
      -- TSAnnotation         { }, -- For C++/Dart attributes, annotations that can be attached to the code to denote some kind of meta information.
      -- TSText               { }, -- For strings considered text in a markup language.
      -- TSStrong             { }, -- For text to be represented with strong.
      -- TSEmphasis           { }, -- For text to be represented with emphasis.
      -- TSUnderline          { }, -- For text to be represented with an underline.
      -- TSTitle              { }, -- Text that is part of a title.
      -- TSLiteral            { }, -- Literal text.
      -- TSURI                { }, -- Any URI like a link or email.
      -- TSVariable           { }, -- Any variable name that does not have another highlight.
      -- TSVariableBuiltin    { }, -- Variable names that are defined by the languages, like `this` or `self`.

      -- }}}

      -- Plugins ------------------------------------------------------------------------------- {{{

      -- Custom groups used as base for Git related highlights
      GitAdd              { fg = c.green },
      GitChange           { fg = c.yellow },
      GitDelete           { fg = c.red },
      GitTopDelete        { GitDelete },
      GitChangeDelete     { fg = c.orange },
      GitAddSign          { GitAdd, gui = SignColumn.gui },
      GitChangeSign       { GitChange, gui = SignColumn.gui },
      GitDeleteSign       { GitDelete, gui = SignColumn.gui },
      GitTopDeleteSign    { GitDeleteSign },
      GitChangeDeleteSign { GitChangeDelete, gui = SignColumn.gui },


      -- vim-gitgutter
      -- https://github.com/airblade/vim-gitgutter
      GitGutterAdd                { GitAdd },
      GitGutterChange             { GitChange },
      GitGutterDelete             { GitDelete },
      GitGutterAddLineNr          { GitAdd, gui = CursorLineNr.gui },
      GitGutterChangeLineNr       { GitChange, gui = CursorLineNr.gui },
      GitGutterDeleteLineNr       { GitDelete, gui = CursorLineNr.gui },
      GitGutterChangeDeleteLineNr { GitChangeDelete, gui = CursorLineNr.gui },


      -- vim-which-key
      -- https://github.com/liuchengxu/vim-which-key
      WhichKeyFloating { NormalFloat },


      -- telescope.nvim
      -- https://github.com/nvim-telescope/telescope.nvim
      -- Sets the highlight for selected items within the picker.
      TelescopeSelection { gui = 'bold,italic' },
      TelescopeSelectionCaret { fg = c.red, gui = 'bold' },
      -- TelescopeMultiSelection { Type }

      -- "Normal" in the floating windows created by telescope.
      TelescopeNormal { Normal },

      -- Border highlight groups.
      TelescopeBorder { fg = c.main, gui = 'bold,italic' },
      TelescopePromptBorder { TelescopeBorder, fg = c.blue },
      TelescopeResultsBorder { TelescopeBorder },
      TelescopePreviewBorder { TelescopeBorder },

      -- Used for highlighting characters that you match.
      TelescopeMatching { fg = c.red },

      -- Used for the prompt prefix
      TelescopePromptPrefix { fg = c.green, gui = 'bold' },

      -- Used for highlighting the matched line inside Previewer.
      -- Works only for (vim_buffer_ previewer)
      TelescopePreviewLine { CursorLine },
      TelescopePreviewMatch { Search },

      -- Used for Picker specific Results highlighting
      -- TelescopeResultsClass { Function },
      -- TelescopeResultsConstant { Constant },
      -- TelescopeResultsField { Function },
      -- TelescopeResultsFunction { Function },
      -- TelescopeResultsMethod { Method },
      -- TelescopeResultsOperator { Operator },
      -- TelescopeResultsStruct { Struct },
      -- TelescopeResultsVariable { SpecialChar },

      -- TelescopeResultsLineNr { LineNr },
      -- TelescopeResultsIdentifier { Identifier },
      -- TelescopeResultsNumber { Number },
      -- TelescopeResultsComment { Comment },
      -- TelescopeResultsSpecialComment { SpecialComment },

      -- Used for git status Results highlighting
      -- TelescopeResultsDiffChange { DiffChange },
      -- TelescopeResultsDiffAdd { DiffAdd },
      -- TelescopeResultsDiffDelete { DiffDelete },


      -- vim-floaterm
      -- https://github.com/voldikss/vim-floaterm
      Floaterm { Normal },
      FloatermBorder { Floaterm, gui = 'bold,italic' },
      FloatermNC { Floaterm },

      -- }}}
    }
  end)
end

return M--.getParsedLushSpec()

-- vim: foldmethod=marker cursorline cursorcolumn signcolumn=yes number
