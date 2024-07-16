-- Git signs
-- gitsigns.nvim
-- https://github.com/lewis6991/gitsigns.nvim
vim.cmd 'packadd gitsigns.nvim'

require'gitsigns'.setup {
  signs = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '≃' },
  },
  numhl = false,
  watch_gitdir = {
    interval = 1000
  },
  sign_priority = 6,
  status_formatter = nil, -- Use default
}
