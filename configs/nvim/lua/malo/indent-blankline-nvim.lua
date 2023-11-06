-- ident-blankline.nvim
-- https://github.com/lukas-reineke/indent-blankline.nvim

require'ibl'.setup {
  indent = {
    char = '│',
  },
  exclude = {
    filetypes = { 'help', 'markdown' },
  },
  scope = {
  char = '┃',
  },
}

