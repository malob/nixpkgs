-- ident-blankline.nvim
-- https://github.com/lukas-reineke/indent-blankline.nvim
vim.cmd 'packadd indent-blankline.nvim'

vim.g.indent_blankline_char = '│'
vim.g.indent_blankline_show_first_indent_level = true
vim.g.indent_blankline_show_trailing_blankline_indent = false
vim.g.indent_blankline_filetype_exclude = { 'help', 'markdown' }

vim.g.indent_blankline_use_treesitter = true
vim.g.indent_blankline_show_current_context = true
