local s = require'malo.utils'.symbols

-- Tabline
-- bufferline.nvim
-- https://github.com/akinsho/bufferline.nvim
vim.cmd 'packadd bufferline-nvim'

require'bufferline.config'.set {
  options = {
    view = 'multiwindow',
    separator_style = 'slant',
    diagnostics = 'nvim_lsp',
    diagnostics_indicator = function(_, level)
      return ' ' .. (
        (level:match('error') and s.errorShape) or
        (level:match('warning') and s.warningShape) or
        s.infoShape
      )
    end,
  },
}
-- Colors are taken care of directly in colorscheme, this hack is needed for that.
require'bufferline'.__load()
vim.cmd 'au! BufferlineColors ColorScheme'
