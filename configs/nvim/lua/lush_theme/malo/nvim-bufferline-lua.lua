-- Custom highlights for nvim-bufferline.lua
-- https://github.com/akinsho/nvim-bufferline.lua
--
-- nvim-bufferline.lua isn't setup to manage it's highlights in this way, but the way they provide
-- does not work well with colorschemes that have dynamic colors, like colors that change based on
-- `vim.o.background`'s value. In order to be able to define the hightlights directly, the following
-- needs to be added: `vim.cmd 'au! BufferlineColors ColorScheme'`.
local t = require'lush_theme.malo'

return require'lush'(function()
  return {
    BufferLineFill           { t.Normal },
    BufferLineBackground     { BufferLineFill, fg = t.Comment.fg },
    BufferLineBufferVisible  { BufferLineBackground, bg = t.StatusLine.bg },
    BufferLineBufferSelected { BufferLineBufferVisible, fg = t.StrongFg.fg, gui = 'bold,italic' },

    BufferLineCloseButton         { BufferLineBackground },
    BufferLineCloseButtonVisible  { BufferLineBufferVisible },
    BufferLineCloseButtonSelected { BufferLineBufferSelected },

    BufferLineModified         { BufferLineBackground , fg = t.ChangeText.fg },
    BufferLineModifiedVisible  { BufferLineBufferVisible, fg = t.ChangeText.fg },
    BufferLineModifiedSelected { BufferLineBufferSelected, fg = t.ChangeText.fg },

    BufferLineDuplicate         { BufferLineBackground },
    BufferLineDuplicateSelected { BufferLineBufferVisible },
    BufferLineDuplicateVisible  { BufferLineBufferSelected },

    BufferLineSeparator         { BufferLineFill, fg = BufferLineFill.bg },
    BufferLineSeparatorVisible  { BufferLineSeparator, bg = BufferLineBufferVisible.bg },
    BufferLineSeparatorSelected { BufferLineSeparatorVisible },
    BufferLineIndicatorSelected { BufferLineBufferVisible, fg = GreenFg.fg },

    BufferLinePick         { t.CyanFg, bg = BufferLineBackground.bg, gui = 'bold,italic' },
    BufferLinePickVisible  { BufferLinePick, bg = BufferLineBufferVisible.bg },
    BufferLinePickSelected { BufferLinePick, bg = BufferLineBufferSelected.bg },

    BufferLineDiagnostic         { BufferLineBackground },
    BufferLineDiagnosticVisible  { BufferLineBufferVisible },
    BufferLineDiagnosticSelected { BufferLineBufferSelected },

    BufferLineError                   { BufferLineDiagnostic },
    BufferLineErrorVisible            { BufferLineDiagnosticVisible },
    BufferLineErrorSelected           { BufferLineDiagnosticSelected },
    BufferLineErrorDiagnostic         { BufferLineDiagnostic, fg = t.ErrorText.fg },
    BufferLineErrorDiagnosticVisible  { BufferLineDiagnosticVisible, fg = t.ErrorText.fg },
    BufferLineErrorDiagnosticSelected { BufferLineDiagnosticSelected, fg = t.ErrorText.fg },

    BufferLineWarning                   { BufferLineDiagnostic },
    BufferLineWarningVisible            { BufferLineDiagnosticVisible },
    BufferLineWarningSelected           { BufferLineDiagnosticSelected },
    BufferLineWarningDiagnostic         { BufferLineDiagnostic, fg = t.WarningText.fg },
    BufferLineWarningDiagnosticVisible  { BufferLineDiagnosticVisible, fg = t.WarningText.fg },
    BufferLineWarningDiagnosticSelected { BufferLineDiagnosticSelected, fg = t.WarningText.fg },

    BufferLineInfo                   { BufferLineDiagnostic },
    BufferLineInfoVisible            { BufferLineDiagnosticVisible },
    BufferLineInfoSelected           { BufferLineDiagnosticSelected },
    BufferLineInfoDiagnostic         { BufferLineDiagnostic },
    BufferLineInfoDiagnosticVisible  { BufferLineDiagnosticVisible },
    BufferLineInfoDiagnosticSelected { BufferLineDiagnosticSelected },

    BufferLineTab         { BufferLineBackground },
    BufferLineTabSelected { BufferLineBufferSelected, gui = 'bold' },
    BufferLineTabClose    { BufferLineBackground },
  }
end)
