-- null-ls.nvim
-- https://github.com/jose-elias-alvarez/null-ls.nvim
vim.cmd 'packadd null-ls.nvim'

local null_ls = require'null-ls'
local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup {
  sources = {
    -- Shell scripts
    code_actions.shellcheck,
    diagnostics.shellcheck,
    -- Markdown
    code_actions.proselint,
    diagnostics.proselint,
    -- Nix
    diagnostics.deadnix,
    diagnostics.statix,
    code_actions.statix,
  }
}
