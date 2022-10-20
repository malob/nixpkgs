-- Custom highlights for bufferline.nvim
-- https://github.com/akinsho/bufferline.nvim
-- See `../../malo/bufferline-nvim.lua` for related configuration.
local t = require'lush_theme.malo'

---@diagnostic disable: undefined-global
return require'lush'(function()
  return {
    BufferLineFill           { t.TabLineFill , sp = t.BlueFg.fg },
    BufferLineBackground     { BufferLineFill, fg = t.Comment.fg },

    BufferLineBuffer         { BufferLineBackground },
    BufferLineBufferVisible  { BufferLineBuffer, bg = t.StatusLine.bg },
    BufferLineBufferSelected { BufferLineBufferVisible, fg = t.StrongFg.fg, gui = 'bold,italic,underline' },

    BufferLineSeparator         { BufferLineFill },
    BufferLineSeparatorVisible  { BufferLineSeparator, bg = BufferLineBufferVisible.bg },
    BufferLineSeparatorSelected { BufferLineSeparatorVisible, gui = 'underline' },

    BufferLineTab                  { BufferLineBuffer },
    BufferLineTabSelected          { BufferLineBufferSelected, gui = 'bold,underline' },
    BufferLineTabClose             { BufferLineTab },
    BufferLineTabSeparator         { BufferLineSeparator },
    BufferLineTabSeparatorSelected { BufferLineSeparatorSelected, gui = 'reverse' },

    BufferLineCloseButton         { BufferLineBuffer },
    BufferLineCloseButtonVisible  { BufferLineBufferVisible },
    BufferLineCloseButtonSelected { BufferLineBufferSelected },

    BufferLineModified         { BufferLineBuffer , fg = t.ChangeText.fg },
    BufferLineModifiedVisible  { BufferLineBufferVisible, fg = t.ChangeText.fg },
    BufferLineModifiedSelected { BufferLineBufferSelected, fg = t.ChangeText.fg },

    BufferLineDuplicate         { BufferLineBuffer },
    BufferLineDuplicateVisible  { BufferLineBufferVisible },
    BufferLineDuplicateSelected { BufferLineBufferVisible, gui = 'underline' },

    BufferLinePick         { BufferLineBuffer, fg = t.CyanFg.fg, gui = 'bold',  },
    BufferLinePickVisible  { BufferLinePick, bg = BufferLineBufferVisible.bg },
    BufferLinePickSelected { BufferLinePick, bg = BufferLineBufferSelected.bg, gui = 'bold,underline' },

    BufferLineDiagnostic         { BufferLineBuffer },
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

    BufferLineRightCustomAreaText1 { BufferLineBuffer },

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
