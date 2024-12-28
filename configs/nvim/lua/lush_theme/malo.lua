-- Colorscheme build in Lua with `lush.nvim`, modeled initially on Solarized, but intended to be
-- usable with alternate colors.
-- Still early days, with lots of work needed
-- https://github.com/rktjmp/lush.nvim
local c = require'malo.theme'.colors

-- Function to set/update colors that are dependant on `vim.o.background`
local function choose(dark, light) return vim.o.background == 'dark' and dark or light end
local function highlight(color)
  return vim.o.background == 'dark' and color.darken(50) or color.lighten(50)
end

---@diagnostic disable: undefined-global
return require'lush'(function(injected_functions)
  local sym = injected_functions.sym
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
    InfoText         { BlueFg },
    HintText         { MutedFg },
    -- }}}

    -- Basic Highlights ------------------------------------------------------------------------ {{{

    Normal      { BaseBg, fg = MainFg.fg },
    NormalNC    { Normal },
    NormalFloat { InvBaseHlBg, fg = MutedFg.fg },

    Comment { MutedFg, gui = 'italic' },

    -- Any constant
    Constant { CyanFg },
    String   { Constant }, -- a string constant: "this is a string"
    -- Character { }, -- a character constant: 'c', '\n'
    -- Number    { }, -- a number constant: 234, 0xff
    -- Boolean   { }, -- a boolean constant: TRUE, false
    -- Float     { }, -- a floating point constant: 2.3e10

    -- Any variable name
    Identifier { BlueFg },
    Function   { Identifier }, -- function name (also: methods for classes)
    sym"@variable" { Identifier },

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
    Delimiter      { Special }, -- character that needs attention
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

    -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is
    -- set.
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

    -- Separator between window splits. Inherts from |hl-VertSplit| by default, which it will
    -- replace eventually.
    -- Winseparator { },

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

    -- These groups are for the native LSP client and diagnostic system. Some other LSP clients may
    -- use these groups, or use their own.
    -- See :h lsp-highlight

    -- Used for highlighting references. See :h document_highlight
    LspReferenceText  { gui = 'underline', sp = CyanBg.bg },
    LspReferenceRead  { LspReferenceText },
    LspReferenceWrite { LspReferenceText, sp = VioletBg.bg },

    -- Used to color the virtual text of the codelens. See |nvim_buf_set_extmark()|.
    -- LspCodeLens                 { } ,

    -- Used to color the seperator between two or more code lens.
    -- LspCodeLensSeparator        { } ,

    -- Used to highlight the active parameter in the signature help. See |vim.lsp.handlers.signature_help()|.
    -- LspSignatureActiveParameter { } ,

    -- }}}

    -- Diagnostics ----------------------------------------------------------------------------- {{{

    -- Used as the base highlight groups. Other Diagnostic highlights link to these by default
    -- (except Underline)
    DiagnosticError { ErrorText },
    DiagnosticWarn  { WarningText },
    DiagnosticInfo  { InfoText },
    DiagnosticHint  { HintText },

    -- Used to underline diagnostics.
    DiagnosticUnderlineError { gui = 'underline', sp = DiagnosticError.fg },
    DiagnosticUnderlineWarn  { DiagnosticUnderlineError, sp = DiagnosticWarn.fg },
    DiagnosticUnderlineInfo  { DiagnosticUnderlineError, sp = DiagnosticInfo.fg },
    DiagnosticUnderlineHint  { DiagnosticUnderlineError, sp = DiagnosticHint.fg },

    -- Used for diagnostics virtual text.
    -- DiagnosticVirtualTextError { } ,
    -- DiagnosticVirtualTextWarn  { } ,
    -- DiagnosticVirtualTextInfo  { } ,
    -- DiagnosticVirtualTextHint  { } ,

    -- Used to color diagnostic messages in diagnostics float. See |vim.diagnostic.open_float()|
    -- DiagnosticFloatingError { } ,
    -- DiagnosticFloatingWarn  { } ,
    -- DiagnosticFloatingInfo  { } ,
    -- DiagnosticFloatingHint  { } ,

    -- Used for diagnostic signs in sign column.
    -- DiagnosticSignError { } ,
    -- DiagnosticSignWarn  { } ,
    -- DiagnosticSignInfo  { } ,
    -- DiagnosticSignHint  { } ,
    -- }}}

    -- TODO: TreeSitter ------------------------------------------------------------------------ {{{

    -- Tree-Sitter syntax groups. Most link to corresponding
    -- vim syntax groups (e.g. TSKeyword => Keyword) by default.
    --
    -- See :h nvim-treesitter-highlights, some groups may not be listed, submit a PR fix to lush-template!
    --
    -- TSAttribute          { } , -- Annotations that can be attached to the code to denote some kind of meta information. e.g. C++/Dart attributes.
    -- TSBoolean            { } , -- Boolean literals: `True` and `False` in Python.
    -- TSCharacter          { } , -- Character literals: `'a'` in C.
    -- TSCharacterSpecial   { } , -- Special characters.
    -- TSComment            { } , -- Line comments and block comments.
    -- TSConditional        { } , -- Keywords related to conditionals: `if`, `when`, `cond`, etc.
    -- TSConstant           { } , -- Constants identifiers. These might not be semantically constant. E.g. uppercase variables in Python.
    -- TSConstBuiltin       { } , -- Built-in constant values: `nil` in Lua.
    -- TSConstMacro         { } , -- Constants defined by macros: `NULL` in C.
    -- TSConstructor        { } , -- Constructor calls and definitions: `{}` in Lua, and Java constructors.
    -- TSDebug              { } , -- Debugging statements.
    -- TSDefine             { } , -- Preprocessor #define statements.
    -- TSError              { } , -- Syntax/parser errors. This might highlight large sections of code while the user is typing still incomplete code, use a sensible highlight.
    -- TSException          { } , -- Exception related keywords: `try`, `except`, `finally` in Python.
    -- TSField              { } , -- Object and struct fields.
    -- TSFloat              { } , -- Floating-point number literals.
    -- TSFunction           { } , -- Function calls and definitions.
    -- TSFuncBuiltin        { } , -- Built-in functions: `print` in Lua.
    -- TSFuncMacro          { } , -- Macro defined functions (calls and definitions): each `macro_rules` in Rust.
    -- TSInclude            { } , -- File or module inclusion keywords: `#include` in C, `use` or `extern crate` in Rust.
    -- TSKeyword            { } , -- Keywords that don't fit into other categories.
    -- TSKeywordFunction    { } , -- Keywords used to define a function: `function` in Lua, `def` and `lambda` in Python.
    -- TSKeywordOperator    { } , -- Unary and binary operators that are English words: `and`, `or` in Python; `sizeof` in C.
    -- TSKeywordReturn      { } , -- Keywords like `return` and `yield`.
    -- TSLabel              { } , -- GOTO labels: `label:` in C, and `::label::` in Lua.
    -- TSMethod             { } , -- Method calls and definitions.
    -- TSNamespace          { } , -- Identifiers referring to modules and namespaces.
    -- TSNone               { } , -- No highlighting (sets all highlight arguments to `NONE`). this group is used to clear certain ranges, for example, string interpolations. Don't change the values of this highlight group.
    -- TSNumber             { } , -- Numeric literals that don't fit into other categories.
    -- TSOperator           { } , -- Binary or unary operators: `+`, and also `->` and `*` in C.
    -- TSParameter          { } , -- Parameters of a function.
    -- TSParameterReference { } , -- References to parameters of a function.
    -- TSPreProc            { } , -- Preprocessor #if, #else, #endif, etc.
    -- TSProperty           { } , -- Same as `TSField`.
    -- TSPunctDelimiter     { } , -- Punctuation delimiters: Periods, commas, semicolons, etc.
    -- TSPunctBracket       { } , -- Brackets, braces, parentheses, etc.
    -- TSPunctSpecial       { } , -- Special punctuation that doesn't fit into the previous categories.
    -- TSRepeat             { } , -- Keywords related to loops: `for`, `while`, etc.
    -- TSStorageClass       { } , -- Keywords that affect how a variable is stored: `static`, `comptime`, `extern`, etc.
    -- TSString             { } , -- String literals.
    -- TSStringRegex        { } , -- Regular expression literals.
    -- TSStringEscape       { } , -- Escape characters within a string: `\n`, `\t`, etc.
    -- TSStringSpecial      { } , -- Strings with special meaning that don't fit into the previous categories.
    -- TSSymbol             { } , -- Identifiers referring to symbols or atoms.
    -- TSTag                { } , -- Tags like HTML tag names.
    -- TSTagAttribute       { } , -- HTML tag attributes.
    -- TSTagDelimiter       { } , -- Tag delimiters like `<` `>` `/`.
    -- TSText               { } , -- Non-structured text. Like text in a markup language.
    -- TSStrong             { } , -- Text to be represented in bold.
    -- TSEmphasis           { } , -- Text to be represented with emphasis.
    -- TSUnderline          { } , -- Text to be represented with an underline.
    -- TSStrike             { } , -- Strikethrough text.
    -- TSTitle              { } , -- Text that is part of a title.
    -- TSLiteral            { } , -- Literal or verbatim text.
    -- TSURI                { } , -- URIs like hyperlinks or email addresses.
    -- TSMath               { } , -- Math environments like LaTeX's `$ ... $`
    -- TSTextReference      { } , -- Footnotes, text references, citations, etc.
    -- TSEnvironment        { } , -- Text environments of markup languages.
    -- TSEnvironmentName    { } , -- Text/string indicating the type of text environment. Like the name of a `\begin` block in LaTeX.
    -- TSNote               { } , -- Text representation of an informational note.
    -- TSWarning            { } , -- Text representation of a warning note.
    -- TSDanger             { } , -- Text representation of a danger note.
    -- TSType               { } , -- Type (and class) definitions and annotations.
    -- TSTypeBuiltin        { } , -- Built-in types: `i32` in Rust.
    -- TSVariable           { } , -- Variable names that don't fit into other categories.
    -- TSVariableBuiltin    { } , -- Variable names defined by the language: `this` or `self` in Javascript.

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

    -- gitsigns.nvim -------------------------------------------------------------------------------

    GitSignAdd       { AddText },
    GitSignChange    { ChangeText },
    GitSignDelete    { DeleteText },
    GitSignTopDelete { DeleteText },

    -- vim-which-key -------------------------------------------------------------------------------
    -- https://github.com/liuchengxu/vim-which-key

    WhichKeyFloating { StatusLine },
    -- }}}
  }
end)
-- vim: foldmethod=marker cursorline cursorcolumn signcolumn=yes number
