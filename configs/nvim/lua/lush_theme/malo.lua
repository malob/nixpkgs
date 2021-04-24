-- Colorscheme build in Lua with `lush.nvim`, modeled initially on Solarized, but intended to be
-- usable with alternate colors.
-- Still early days, with lots of work needed
-- https://github.com/rktjmp/lush.nvim
local c = require'malo.theme'.colors

-- Function to set/update colors that are dependant on `vim.o.background`
local function choose(dark, light) return vim.o.background == 'dark' and dark or light end
local function highlight(c) return vim.o.background == 'dark' and c.lightness(20) or c.lightness(80) end

return require'lush'(function()
  return {
    -- Building Blocks ------------------------------------------------------------------------- {{{

    -- Basic colors
    DarkBaseBg     { bg = c.darkBase },
    DarkBaseHlBg   { bg = c.darkBaseHl },
    DarkestToneBg  { bg = c.darkestTone },
    DarkToneBg     { bg = c.darkTone },
    LightToneBg    { bg = c.lightTone },
    LightestToneBg { bg = c.lightestTone },
    LightBaseHlBg  { bg = c.lightBaseHl },
    LightBaseBg    { bg = c.lightBase },
    YellowBg       { bg = c.yellow },
    OrangeBg       { bg = c.orange },
    RedBg          { bg = c.red },
    MagentaBg      { bg = c.magenta },
    VioletBg       { bg = c.violet },
    BlueBg         { bg = c.blue },
    CyanBg         { bg = c.cyan },
    GreenBg        { bg = c.green },
    DarkBaseFg     { fg = DarkBaseBg.bg },
    DarkBaseHlFg   { fg = DarkBaseHlBg.bg },
    DarkestToneFg  { fg = DarkestToneBg.bg },
    DarkToneFg     { fg = DarkToneBg.bg },
    LightToneFg    { fg = LightToneBg.bg },
    LightestToneFg { fg = LightestToneBg.bg },
    LightBaseHlFg  { fg = LightBaseHlBg.bg },
    LightBaseFg    { fg = LightBaseBg.bg },
    YellowFg       { fg = YellowBg.bg },
    OrangeFg       { fg = OrangeBg.bg },
    RedFg          { fg = RedBg.bg },
    MagentaFg      { fg = MagentaBg.bg },
    VioletFg       { fg = VioletBg.bg },
    BlueFg         { fg = BlueBg.bg },
    CyanFg         { fg = CyanBg.bg },
    GreenFg        { fg = GreenBg.bg },

    -- Colors dependant on background color
    BaseBg      { bg = choose(c.darkBase, c.lightBase) },
    BaseHlBg    { bg = choose(c.darkBaseHl, c.lightBaseHl) },
    InvBaseBg   { bg = choose(c.lightBase, c.darkBase) },
    InvBaseHlBg { bg = choose(c.lightBaseHl, c.darkBaseHl) },
    MainBg      { bg = choose(c.lightTone, c.darkTone) },
    FadedBg     { bg = choose(c.darkTone, c.lightTone) },
    MutedBg     { bg = choose(c.darkestTone, c.lightestTone) },
    StrongBg    { bg = choose(c.lightestTone , c.darkestTone) },
    BaseFg      { fg = BaseBg.bg },
    BasheHlFg   { fg = BasheHlBg.bg },
    InvBaseFg   { fg = InvBaseBg.bg },
    InvBaseHlFg { fg = InvBaseHlBg.bg },
    MainFg      { fg = MainBg.bg },
    FadedFg     { fg = FadedBg.bg },
    MutedFg     { fg = MutedBg.bg },
    StrongFg    { fg = StrongBg.bg },
    YellowHlBg  { bg = highlight(c.yellow) },
    OrangeHlBg  { bg = highlight(c.orange) },
    RedHlBg     { bg = highlight(c.red) },
    MagentaHlBg { bg = highlight(c.magenta) },
    VioletHlBg  { bg = highlight(c.violet) },
    BlueHlBg    { bg = highlight(c.blue) },
    CyanHlBg    { bg = highlight(c.cyan) },
    GreenHlBg   { bg = highlight(c.green) },

    -- Misc
    AddText          { GreenFg },
    ChangeText       { YellowFg },
    DeleteText       { RedFg },
    ChangeDeleteText { OrangeFg },
    ErrorText        { RedFg },
    WarningText      { YellowFg },
    -- }}}

    -- Basic Highlights ------------------------------------------------------------------------ {{{

    Normal      { BaseBg, fg = MainFg.fg },
    NormalNC    { Normal },
    NormalFloat { InvBaseHlBg, fg = MutedFg.fg },

    Comment { MutedFg, gui = 'italic' },

    -- Any constant
    Constant { CyanFg },
    -- String    { }, -- a string constant: "this is a string"
    -- Character { }, -- a character constant: 'c', '\n'
    -- Number    { }, -- a number constant: 234, 0xff
    -- Boolean   { }, -- a boolean constant: TRUE, false
    -- Float     { }, -- a floating point constant: 2.3e10

    -- Any variable name
    Identifier { BlueFg },
    -- Function { }, -- function name (also: methods for classes)

    -- Any statement
    Statement { GreenFg, gui = 'bold,italic' },
    -- Conditional { }, -- if, then, else, endif, switch, etc.
    -- Repeat      { }, -- for, do, while, etc.
    -- Label       { }, -- case, default, etc.
    Operator    { Statement, gui = '' }, -- "sizeof", "+", "*", etc.
    -- Keyword     { }, -- any other keyword
    -- Exception   { }, -- try, catch, throw

    -- Generic Preprocessor
    PreProc { OrangeFg },
    -- Include   { }, -- preprocessor #include
    -- Define    { }, -- preprocessor #define
    -- Macro     { }, -- same as Define
    -- PreCondit { }, -- preprocessor #if, #else, #endif, etc.

    -- int, long, char, etc.
    Type { YellowFg },
    -- StorageClass { }, -- static, register, volatile, etc.
    -- Structure    { }, -- struct, union, enum, etc.
    -- Typedef      { }, -- A typedef

    -- Any special symbol
    Special { RedFg },
    -- SpecialChar    { }, -- special character in a constant
    -- Tag            { }, -- you can use CTRL-] on this
    -- Delimiter      { }, -- character that needs attention
    -- SpecialComment { }, -- special things inside a comment
    -- Debug          { }, -- debugging statements

    -- Left blank, hidden
    Ignore { },

    -- Any erroneous construct
    Error { ErrorText, gui = 'bold' },

    -- Anything that needs extra attention; mostly the keywords TODO FIXME and XXX
    Todo { MagentaFg, gui = 'bold' },

    Underlined { gui = 'underline' },
    Bold       { gui = 'bold' },
    Italic     { gui = 'italic' },
    --- }}}

    -- Neovim UI ------------------------------------------------------------------------------- {{{


    -- Cursors -------------------------------------------------------------------------------------

    -- Character under the cursor
    Cursor       { BlueBg, fg = Normal.bg },

    -- The character under the cursor when |language-mapping| is used (see 'guicursor').
    lCursor      { Cursor },

   -- Like Cursor, but used when in IME mode |CursorIM|
    CursorIM     { Cursor },

    -- Cursor in a focused terminal
    TermCursor   { Cursor },

    -- Cursor in an unfocused terminal
    TermCursorNC { Normal, gui = 'reverse' },


    -- Search --------------------------------------------------------------------------------------

    -- Last search pattern highlighting (see 'hlsearch').
    -- Also used for similar items that need to stand out.
    Search    { YellowHlBg },

    -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
    IncSearch { OrangeHlBg },

    -- |:substitute| replacement text highlighting
    -- Sustitute { },

    -- Selections ----------------------------------------------------------------------------------

    -- Visual mode selection
    Visual    { BlueHlBg  },

    -- Visual mode selection when vim is "Not Owning the Selection".
    VisualNOS { Normal, gui = 'reverse'  },


    -- Statusline ----------------------------------------------------------------------------------

    -- Status line of current window.
    StatusLine   { BaseHlBg },

    -- Status lines of not-current windows. Note: if this is equal to "StatusLine" Vim will use
    -- "^^^" in the status line of the current window.
    StatusLineNC { StatusLine, fg = FadedFg.fg },


    -- Tabline -------------------------------------------------------------------------------------

    -- Not active tab page label.
    TabLine     { StatusLine },

    -- Where there are no labels.
    TabLineFill { bg = Normal.bg, fg = Normal.bg },

    -- Active tab page label.
    TabLineSel  { TabLine, gui = 'bold,italic' },


    -- Columns and other lines ---------------------------------------------------------------------

    -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
    LineNr       { MutedFg },

    -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
    CursorLineNr { BlueFg, gui = 'bold' },

    -- Column where |signs| are displayed.
    SignColumn   { bg = LineNr.bg, gui = 'bold' },

    -- Screen-column at the cursor, when 'cursorcolumn' is set.
    CursorColumn { bg = StatusLine.bg },

    -- Screen-line at the cursor, when 'cursorline' is set.
    -- Low-priority if foreground (ctermfg OR guifg) is not set.
    CursorLine   { CursorColumn },

    -- Used for the columns set with 'colorcolumn'.
    ColorColumn  { CursorColumn },

    -- The column separating vertically split windows.
    VertSplit    { LineNr, gui = 'bold' },

    -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor
    -- is there.
    -- QuickFixLine { },

    -- Folds ---------------------------------------------------------------------------------------

    -- Line used for closed folds.
    Folded     { CursorLine, gui = 'bold' },

    -- See 'foldcolumn'
    FoldColumn { CursorLine },


    -- Popup menu ----------------------------------------------------------------------------------

    -- Normal item
    Pmenu      { NormalFloat },

    -- Selected item
    PmenuSel   { Pmenu, gui = 'bold', blend = 0 },

    -- Scrollbar
    PmenuSbar  { InvBaseBg },

    -- Thumb of the scrollbar
    PmenuThumb { Pmenu, gui = 'reverse' },


    -- Diff mode -----------------------------------------------------------------------------------

    -- Added line |diff.txt|
    DiffAdd    { AddText, bg = CursorLine.bg, gui = 'bold' },

    -- Changed line |diff.txt|
    DiffChange { ChangeText, bg = CursorLine.bg, gui = 'bold' },

    -- Deleted line |diff.txt|
    DiffDelete { DeleteText, bg = CursorLine.bg, gui = 'bold' },

    -- Changed text within a changed line |diff.txt|
    DiffText   { BlueFg, bg = CursorLine.bg, gui = 'bold' },


    -- Spell checker -------------------------------------------------------------------------------

    -- Word that is not recognized by the spellchecker. Combined with the highlighting used
    -- otherwise.
    SpellBad   { gui = 'undercurl', sp = c.red },


    -- Word that should start with a capital. Combined with the highlighting used otherwise.
    SpellCap   { gui = 'undercurl', sp = c.violet },

    -- Word that is recognized by the spellchecker as one that is hardly ever used. Combined with
    -- the highlighting used otherwise.
    SpellRare  { gui = 'undercurl', sp = c.cyan },

    -- Word that is recognized by the spellchecker as one that is used in another region. Combined
    -- with the highlighting used otherwise.
    SpellLocal { gui = 'undercurl', sp = c.yellow },


    -- Messages, prompts, etc. ---------------------------------------------------------------------

    -- Area for messages and cmdline
    MsgArea { Normal, fg = Comment.fg },

    -- Separator for scrolled messages, `msgsep` flag of 'display'
    -- MsgSeparator { },

    -- Error messages on the command line
    ErrorMsg   { ErrorText, gui = 'bold' },

    -- Warning messages
    WarningMsg { WarningText, gui = 'bold' },

    -- 'showmode' message (e.g., "-- INSERT -- ")
    ModeMsg    { BlueFg },

    -- |more-prompt|
    MoreMsg    { ModeMsg },

    -- Directory names (and other special names in listings)
    Directory  { BlueFg },

    -- |hit-enter| prompt and yes/no questions
    Question   { CyanFg, gui = 'bold' },

    -- Titles for output from ":set all", ":autocmd" etc.
    Title      { OrangeFg, gui = 'bold' },


    -- Other character highlights ------------------------------------------------------------------

    -- Placeholder characters substituted for concealed text (see 'conceallevel')
    Conceal    { BlueFg },

    -- The character under the cursor or just before it, if it is a paired bracket,
    -- and its match. |pi_paren.txt|
    MatchParen { RedFg, gui = 'reverse,bold' },

    -- Unprintable characters: text displayed differently from what it really is.
    SpecialKey { Comment, gui = 'bold' },

    -- '@' at the end of the window, characters from 'showbreak' and other characters that do not
    -- really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at
    -- the end of the line). See also |hl-EndOfBuffer|.
    NonText    { Comment, gui = 'bold' },

    -- filler lines (~) after the end of the buffer. By default, this is highlighted like
    -- |hl-NonText|.
    -- EndOfBuffer { },

    -- Current match in 'wildmenu' completion
    WildMenu   { PmenuSel },

    -- "nbsp", "space", "tab" and "trail" in 'listchars'
    -- Whitespace { },
    -- }}}

    -- Builtin LSP ----------------------------------------------------------------------------- {{{

    -- Default groups are used as the base highlight group. Other LspDiagnostic highlights link to
    -- this by default (except Underline)

    LspDiagnosticsDefaultError     { ErrorText },
    -- LspDiagnosticsVirtualTextError { }, -- used for "Error" diagnostic virtual text.
    -- LspDiagnosticsFloatingError    { }, -- used for "Error" diagnostic messages in the diagnostics float
    -- LspDiagnosticsSignError        { }, -- used for "Error" diagnostic signs in sign column

    LspDiagnosticsDefaultWarning     { WarningText },
    -- LspDiagnosticsVirtualTextWarning { }, -- used for "Warning" diagnostic virtual text.
    -- LspDiagnosticsFloatingWarning    { }, -- used for "Warning" diagnostic messages in the diagnostics float
    -- LspDiagnosticsSignWarning        { }, -- used for "Warning" diagnostic signs in sign column

    LspDiagnosticsDefaultInformation     { Comment },
    -- LspDiagnosticsVirtualTextInformation { }, -- used for "Information" diagnostic virtual text.
    -- LspDiagnosticsFloatingInformation    { }, -- used for "Information" diagnostic messages in the diagnostics float
    -- LspDiagnosticsSignInformation        { }, -- used for "Information" signs in sign column

    LspDiagnosticsDefaultHint     { Comment },
    -- LspDiagnosticsVirtualTextHint { }, -- used for "Hint" diagnostic virtual text.
    -- LspDiagnosticsFloatingHint    { }, -- used for "Hint" diagnostic messages in the diagnostics float
    -- LspDiagnosticsSignHint        { }, -- used for "Hint" diagnostic signs in sign column

    LspDiagnosticsUnderlineError       { gui = 'undercurl', sp = ErrorText.fg },   -- used to underline "Error" diagnostics.
    LspDiagnosticsUnderlineWarning     { gui = 'undercurl', sp = WarningText.fg }, -- used to underline "Warning" diagnostics.
    LspDiagnosticsUnderlineInformation { gui = 'undercurl', sp = StrongFg.fg },    -- used to underline "Information" diagnostics.
    LspDiagnosticsUnderlineHint        { gui = 'undercurl', sp = StrongFg.fg },    -- used to underline "Hint" diagnostics.

    -- TODO: what are these?
    -- LspReferenceText  { }, -- used for highlighting "text" references
    -- LspReferenceRead  { }, -- used for highlighting "read" references
    -- LspReferenceWrite { }, -- used for highlighting "write" references
    -- }}}

    -- TODO: TreeSitter ------------------------------------------------------------------------ {{{

    -- These groups are for the neovim tree-sitter highlights. As of writing, tree-sitter support is
    -- a WIP, group names may change. By default, most of these groups link to an appropriate Vim
    -- group, TSError -> Error for example, so you do not have to define these unless you explicitly
    -- want to support Treesitter's improved syntax awareness.

    -- TSAnnotation         { }, -- For C++/Dart attributes, annotations that can be attached to the code to denote some kind of meta information.
    -- TSAttribute          { }, -- (unstable) TODO: docs
    -- TSBoolean            { }, -- For booleans.
    -- TSCharacter          { }, -- For characters.
    -- TSComment            { }, -- For comment blocks.
    -- TSConstructor        { }, -- For constructor calls and definitions: ` { }` in Lua, and Java constructors.
    -- TSConditional        { }, -- For keywords related to conditionnals.
    -- TSConstant           { }, -- For constants
    -- TSConstBuiltin       { }, -- For constant that are built in the language: `nil` in Lua.
    -- TSConstMacro         { }, -- For constants that are defined by macros: `NULL` in C.
    -- TSError              { }, -- For syntax/parser errors.
    -- TSException          { }, -- For exception related keywords.
    -- TSField              { }, -- For fields.
    -- TSFloat              { }, -- For floats.
    -- TSFunction           { }, -- For function (calls and definitions).
    -- TSFuncBuiltin        { }, -- For builtin functions: `table.insert` in Lua.
    -- TSFuncMacro          { }, -- For macro defined fuctions (calls and definitions): each `macro_rules` in Rust.
    -- TSInclude            { }, -- For includes: `#include` in C, `use` or `extern crate` in Rust, or `require` in Lua.
    -- TSKeyword            { }, -- For keywords that don't fall in previous categories.
    -- TSKeywordFunction    { }, -- For keywords used to define a fuction.
    -- TSLabel              { }, -- For labels: `label:` in C and `:label:` in Lua.
    -- TSMethod             { }, -- For method calls and definitions.
    -- TSNamespace          { }, -- For identifiers referring to modules and namespaces.
    -- TSNone               { }, -- TODO: docs
    -- TSNumber             { }, -- For all numbers
    -- TSOperator           { }, -- For any operator: `+`, but also `->` and `*` in C.
    -- TSParameter          { }, -- For parameters of a function.
    -- TSParameterReference { }, -- For references to parameters of a function.
    -- TSProperty           { }, -- Same as `TSField`.
    -- TSPunctDelimiter     { }, -- For delimiters ie: `.`
    -- TSPunctBracket       { }, -- For brackets and parens.
    -- TSPunctSpecial       { }, -- For special punctutation that does not fall in the catagories before.
    -- TSRepeat             { }, -- For keywords related to loops.
    -- TSString             { }, -- For strings.
    -- TSStringRegex        { }, -- For regexes.
    -- TSStringEscape       { }, -- For escape characters within a string.
    -- TSSymbol             { }, -- For identifiers referring to symbols or atoms.
    -- TSType               { }, -- For types.
    -- TSTypeBuiltin        { }, -- For builtin types.
    -- TSVariable           { }, -- Any variable name that does not have another highlight.
    -- TSVariableBuiltin    { }, -- Variable names that are defined by the languages, like `this` or `self`.

    -- TSTag                { }, -- Tags like html tag names.
    -- TSTagDelimiter       { }, -- Tag delimiter like `<` `>` `/`
    TSText               { fg = Normal.fg },    -- For strings considered text in a markup language.
    TSEmphasis           { gui = 'italic' },    -- For text to be represented with emphasis.
    TSUnderline          { gui = 'underline' }, -- For text to be represented with an underline.
    -- TSStrike             { }, -- For strikethrough text.
    -- TSTitle              { }, -- Text that is part of a title.
    -- TSLiteral            { }, -- Literal text.
    -- TSURI                { }, -- Any URI like a link or email.

    -- }}}

    -- Plugins --------------------------------------------------------------------------------- {{{


    -- vim-floaterm --------------------------------------------------------------------------------
    -- https://github.com/voldikss/vim-floaterm

    Floaterm       { Normal },
    FloatermNC     { Floaterm },
    FloatermBorder { Floaterm, gui = 'bold,italic' },


    -- vim-gitgutter -------------------------------------------------------------------------------
    -- https://github.com/airblade/vim-gitgutter

    GitGutterAdd                { AddText },
    GitGutterChange             { ChangeText },
    GitGutterDelete             { DeleteText },
    GitGutterAddLineNr          { AddText },
    GitGutterChangeLineNr       { ChangeText },
    GitGutterDeleteLineNr       { DeleteText },
    GitGutterChangeDeleteLineNr { ChangeDeleteText },


    -- vim-which-key -------------------------------------------------------------------------------
    -- https://github.com/liuchengxu/vim-which-key

    WhichKeyFloating { StatusLine },
    -- }}}
  }
end)
-- vim: foldmethod=marker cursorline cursorcolumn signcolumn=yes number
