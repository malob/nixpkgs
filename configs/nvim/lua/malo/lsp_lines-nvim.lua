-- lsp_lines.nvim
-- https://git.sr.ht/~whynothugo/lsp_lines.nvim
vim.cmd 'packadd lsp_lines.nvim'

require'lsp_lines'.setup()

vim.diagnostic.config({ virtual_lines = { only_current_line = true } })
