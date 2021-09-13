-- Git signs
-- gitsigns.nvim
-- https://github.com/lewis6991/gitsigns.nvim
vim.cmd 'packadd gitsigns.nvim'

require'gitsigns'.setup {
  signs = {
    add          = { hl = 'AddText'          , text = '┃' , numhl='' },
    change       = { hl = 'ChangeText'       , text = '┃' , numhl='' },
    delete       = { hl = 'DeleteText'       , text = '_' , numhl='' },
    topdelete    = { hl = 'DeleteText'       , text = '‾' , numhl='' },
    changedelete = { hl = 'ChangeDeleteText' , text = '≃' , numhl='' },
  },
  numhl = false,
  keymaps = {},
  watch_index = {
    interval = 1000
  },
  sign_priority = 6,
  status_formatter = nil, -- Use default
}
