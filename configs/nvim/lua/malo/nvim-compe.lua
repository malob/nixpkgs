local keymaps = require'malo.utils'.keymaps

-- nvim-compe
-- https://github.com/hrsh7th/nvim-compe
vim.cmd 'packadd nvim-compe'

-- Recommended option settings
vim.o.completeopt = 'menuone,noselect'
vim.o.shortmess   = vim.o.shortmess .. 'c' -- don't show extra message when using completion

-- Use <Tab> and <S-Tab> to navigate through popup menu, <CR> to confirm.
keymaps { modes = 'i', opts = { noremap = true, expr = true }, maps = {
  { '<Tab>'   , function() return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'   end },
  { '<S-Tab>' , function() return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>' end },
  { '<CR>'    , [[compe#confirm('<CR>')]] },
}}

-- Completion settings
require'compe'.setup {
  documentation = {
    border = "rounded",
  },
  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,

    -- External plugins
    tabnine = true,
  },
}
