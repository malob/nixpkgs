local utils = require 'malo.utils'
local s = utils.symbols

-- lspsaga.nvim
-- A light-weight lsp plugin based on neovim built-in lsp with highly a performant UI.
-- https://github.com/glepnir/lspsaga.nvim
vim.cmd 'packadd lspsaga-nvim'

require'lspsaga'.init_lsp_saga {
  use_saga_diagnostic_sign = true,
  error_sign = s.error,
  warn_sign = s.warning,
  infor_sign = s.info,
  hint_sign = s.question,
  dianostic_header_icon = '  ',
  code_action_icon = ' ',
  code_action_prompt = {
    enable = true,
    sign = false,
    sign_priority = 20,
    virtual_text = true,
  },
  -- finder_definition_icon = '  ',
  -- finder_reference_icon = '  ',
  -- max_preview_lines = 10, -- preview lines of lsp_finder and definition preview
  -- finder_action_keys = {
  --   open = 'o', vsplit = 's',split = 'i',quit = 'q',scroll_down = '<C-f>', scroll_up = '<C-b>' -- quit can be a table
  -- },
  code_action_keys = {
    quit = '<ESC>', exec = '<CR>'
  },
  rename_action_keys = {
    quit = '<ESC>', exec = '<CR>'
  },
  -- definition_preview_icon = '  '
  -- border_style = "round" -- "single" "double" "round" "plus"
  rename_prompt_prefix = '❯',
}

-- Show LSP diagnostics in popups on cursor hold, not in virtual text
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    update_in_insert = false,
  }
)
utils.augroup { name = 'LSP', cmds = {
  { 'CursorHold', '*', "lua require'lspsaga.diagnostic'.show_line_diagnostics()" }
}}