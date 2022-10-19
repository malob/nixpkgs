-- Custom highlights for bufferline.nvim
-- https://github.com/akinsho/bufferline.nvim
--
-- nvim-bufferline.lua isn't setup to manage it's highlights in this way, but the way they provide
-- does not work well with colorschemes that have dynamic colors, like colors that change based on
-- `vim.o.background`'s value. In order to be able to define the hightlights directly, the following
-- needs to be added: `vim.cmd 'au! BufferlineColors ColorScheme'`.
local t = require'lush_theme.malo'

---@diagnostic disable: undefined-global
return require'lush'(function()
  return {
    BufferLineFill           { t.Normal },
    BufferLineBackground     { BufferLineFill, fg = t.Comment.fg },

    BufferLineBuffer         { BufferLineBackground },
    BufferLineBufferVisible  { BufferLineBuffer, bg = t.StatusLine.bg },
    BufferLineBufferSelected { BufferLineBufferVisible, fg = t.StrongFg.fg, gui = 'bold,italic,underline', sp = t.BlueFg.fg },

    BufferLineSeparator         { BufferLineFill, fg = BufferLineFill.bg },
    BufferLineSeparatorVisible  { BufferLineSeparator, bg = BufferLineBufferVisible.bg },
    BufferLineSeparatorSelected { BufferLineSeparatorVisible, gui = 'underline', sp = BufferLineBufferSelected.sp },

    BufferLineTab         { BufferLineBackground },
    BufferLineTabSelected { BufferLineBufferSelected, gui = 'bold,underline' },
    BufferLineTabClose    { BufferLineBackground },
    BufferLineTabSeparator { BufferLineSeparator },
    BufferLineTabSeparatorSelected { BufferLineSeparatorSelected, gui = 'reverse' },

    BufferLineCloseButton         { BufferLineBackground },
    BufferLineCloseButtonVisible  { BufferLineBufferVisible },
    BufferLineCloseButtonSelected { BufferLineBufferSelected },

    BufferLineModified         { BufferLineBackground , fg = t.ChangeText.fg },
    BufferLineModifiedVisible  { BufferLineBufferVisible, fg = t.ChangeText.fg },
    BufferLineModifiedSelected { BufferLineBufferSelected, fg = t.ChangeText.fg },

    BufferLineDuplicate         { BufferLineBackground },
    BufferLineDuplicateVisible  { BufferLineBufferVisible },
    BufferLineDuplicateSelected { BufferLineBufferVisible, gui = 'underline', sp = BufferLineBufferSelected.sp },

    BufferLinePick         { t.CyanFg, bg = BufferLineBackground.bg, gui = 'bold,italic' },
    BufferLinePickVisible  { BufferLinePick, bg = BufferLineBufferVisible.bg },
    BufferLinePickSelected { BufferLinePick, bg = BufferLineBufferSelected.bg },

    BufferLineDiagnostic         { BufferLineBackground },
    BufferLineDiagnosticVisible  { BufferLineBufferVisible },
    BufferLineDiagnosticSelected { BufferLineBufferSelected },

    BufferLineError                   { BufferLineDiagnostic },
    BufferLineErrorVisible            { BufferLineDiagnosticVisible },
    BufferLineErrorSelected           { BufferLineDiagnosticSelected },
    BufferLineErrorDiagnostic         { BufferLineError, fg = t.ErrorText.fg },
    BufferLineErrorDiagnosticVisible  { BufferLineErrorVisible, fg = t.ErrorText.fg },
    BufferLineErrorDiagnosticSelected { BufferLineErrorSelected, fg = t.ErrorText.fg },

    BufferLineWarning                   { BufferLineDiagnostic },
    BufferLineWarningVisible            { BufferLineDiagnosticVisible },
    BufferLineWarningSelected           { BufferLineDiagnosticSelected },
    BufferLineWarningDiagnostic         { BufferLineWarning, fg = t.WarningText.fg },
    BufferLineWarningDiagnosticVisible  { BufferLineWarningVisible, fg = t.WarningText.fg },
    BufferLineWarningDiagnosticSelected { BufferLineWarningSelected, fg = t.WarningText.fg },

    BufferLineInfo                   { BufferLineDiagnostic },
    BufferLineInfoVisible            { BufferLineDiagnosticVisible },
    BufferLineInfoSelected           { BufferLineDiagnosticSelected },
    BufferLineInfoDiagnostic         { BufferLineInfo, fg = t.InfoText.fg },
    BufferLineInfoDiagnosticVisible  { BufferLineInfoVisible, fg = t.InfoText.fg },
    BufferLineInfoDiagnosticSelected { BufferLineInfoSelected, fg = t.InfoText.fg },

    BufferLineHint                   { BufferLineDiagnostic },
    BufferLineHintVisible            { BufferLineDiagnosticVisible },
    BufferLineHintSelected           { BufferLineDiagnosticSelected },
    BufferLineHintDiagnostic         { BufferLineHint, fg = t.HintText.fg },
    BufferLineHintDiagnosticVisible  { BufferLineHintVisible, fg = t.HintText.fg },
    BufferLineHintDiagnosticSelected { BufferLineHintSelected, fg = t.HintText.fg },

    -- Not currently implemented
    -- BufferLineIndicatorVisible
    -- BufferLineIndicatorSelected
    -- BufferLineGroupLabel
    -- BufferLineGroupSeparator
    -- BufferLineNumbers
    -- BufferLineNumbersSelected
    -- BufferLineNumbersVisible
    -- BufferLineOffsetSeparator
  }
end)
