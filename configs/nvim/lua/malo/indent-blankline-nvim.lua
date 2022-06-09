-- ident-blankline.nvim
-- https://github.com/lukas-reineke/indent-blankline.nvim
vim.cmd 'packadd indent-blankline.nvim'

require'indent_blankline'.setup {
  char = '│',
  show_trailing_blankline_indent = false,
  buftype_exclude = { 'terminal' },
  filetype_exclude = { 'help', 'markdown' },

  use_treesitter = true,
  show_current_context = true,
  context_char = '┃',
}

