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

    BufferLineModified         { BufferLineBackground , fg = t.YellowFg.fg },
    BufferLineModifiedVisible  { BufferLineBufferVisible, fg = t.YellowFg.fg },
    BufferLineModifiedSelected { BufferLineBufferSelected, fg = t.YellowFg.fg },

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

    BufferLineWarning         { BufferLineBackground, fg = t.LspDiagnosticsDefaultWarning.fg },
    BufferLineWarningVisible  { BufferLineBufferVisible, fg = t.LspDiagnosticsDefaultWarning.fg },
    BufferLineWarningSelected { BufferLineBufferSelected, fg = t.LspDiagnosticsDefaultWarning.fg },
    BufferLineError           { BufferLineBackground, fg = t.LspDiagnosticsDefaultError.fg },
    BufferLineErrorVisible    { BufferLineBufferVisible, fg = t.LspDiagnosticsDefaultError.fg },
    BufferLineErrorSelected   { BufferLineBufferSelected, fg = t.LspDiagnosticsDefaultError.fg },

    BufferLineTab         { BufferLineBackground },
    BufferLineTabSelected { BufferLineBufferSelected, gui = 'bold' },
    BufferLineTabClose    { BufferLineBackground },
  }
end)
