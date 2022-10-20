local s = require'malo.utils'.symbols
-- Tabline
-- bufferline.nvim
-- https://github.com/akinsho/bufferline.nvim
vim.cmd 'packadd bufferline.nvim'

require 'scope'.setup()
require 'bufferline'.setup {
  options = {
    themable = true,
    -- view = 'multiwindow',
    separator_style = 'slant',
    diagnostics = 'nvim_lsp',
    diagnostics_indicator = function(_, level)
      return ' ' .. (
        (level:match('error') and s.errorShape) or
        (level:match('warning') and s.warningShape) or
        s.infoShape
      )
    end,
    custom_areas = { right = function() return { { text = ' ' .. os.date('%H:%M') } } end }
  },
  -- Highlights or mostly defined in `../lush_theme/malo/bufferline-nvim.lua` but the following is
  -- required to get icon highlights to display correctly, since `bufferline.nvim` generates them
  -- on the fly based on these values.
  highlights = {
    background = {
      bg = {
        attribute = 'bg',
        highlight = 'Normal',
      },
      fg = {
        attribute = 'fg',
        highlight = 'Comment',
      },
    },
    buffer_visible = {
      bg = {
        attribute = 'bg',
        highlight = 'StatusLine',
      },
      fg = {
        attribute = 'fg',
        highlight = 'Comment',
      },
    },
    buffer_selected = {
      bg = {
        attribute = 'bg',
        highlight = 'StatusLine',
      },
      fg = {
        attribute = 'fg',
        highlight = 'StrongFg',
      },
      underline = true,
      sp = {
        attribute = 'fg',
        highlight = 'BlueFg',
      },
    },
  },
}
