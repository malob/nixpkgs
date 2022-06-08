local utils = require'malo.utils'

-- toggleterm.nvim
-- https://github.com/akinsho/toggleterm.nvim
vim.cmd 'packadd toggleterm.nvim'
require'toggleterm'.setup {
  shade_terminals = false,
  float_opts = {
    border = 'curved',
  },
}
utils.augroup { name = 'MaloToggleTermKeymaps', cmds = {
  { 'FileType', {
    pattern = 'toggleterm',
    desc = 'Load floating terminal keymaps.',
    callback = function ()
      utils.keymaps { modes = '', opts = { buffer = true, silent = true }, maps = {
        { '<ESC>', '<Cmd>ToggleTerm<CR>' },
      }}
    end
  }},
}}
