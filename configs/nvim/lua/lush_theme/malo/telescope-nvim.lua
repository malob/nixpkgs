-- Highlights for telescope.nvim
-- https://github.com/akinsho/nvim-bufferline.lua
local t = require'lush_theme.malo'

return require'lush'(function()
  return {
    TelescopeNormal { t.Normal },

    -- Selection
    TelescopeSelection      { t.Visual },
    TelescopeMultiSelection { t.Search },
    TelescopeSelectionCaret { TelescopeSelection, fg = t.RedFg.fg, gui = 'bold' },

    -- Border
    TelescopeBorder        { t.MainFg, gui = 'bold,italic' },
    TelescopePromptBorder  { TelescopeBorder, fg = t.BlueFg.fg },
    TelescopeResultsBorder { TelescopeBorder },
    TelescopePreviewBorder { TelescopeBorder },

    -- Used for highlighting characters that you match.
    TelescopeMatching { t.RedFg },

    -- Used for the prompt prefix
    TelescopePromptPrefix { t.GreenFg, gui = 'bold' },

    -- Used for highlighting the matched line inside Previewer.
    -- Works only for (vim_buffer_previewer)
    TelescopePreviewLine  { t.CursorLine },
    TelescopePreviewMatch { t.Search },

    -- Used for Picker specific Results highlighting
    -- TelescopeResultsClass    { Function },
    -- TelescopeResultsConstant { Constant },
    -- TelescopeResultsField    { Function },
    -- TelescopeResultsFunction { Function },
    -- TelescopeResultsMethod   { Method },
    -- TelescopeResultsOperator { Operator },
    -- TelescopeResultsStruct   { Struct },
    -- TelescopeResultsVariable { SpecialChar },

    -- TelescopeResultsLineNr         { LineNr },
    -- TelescopeResultsIdentifier     { Identifier },
    -- TelescopeResultsNumber         { Number },
    -- TelescopeResultsComment        { Comment },
    -- TelescopeResultsSpecialComment { SpecialComment },

    -- Used for git status Results highlighting
    -- TelescopeResultsDiffChange { DiffChange },
    -- TelescopeResultsDiffAdd    { DiffAdd },
    -- TelescopeResultsDiffDelete { DiffDelete },
  }
end)
