local utils = require 'malo.utils'
local s = utils.symbols

-- lspsaga.nvim (fork)
-- A light-weight lsp plugin based on neovim built-in lsp with highly a performant UI.
-- https://github.com/tami5/lspsaga.nvim
vim.cmd 'packadd lspsaga.nvim'

require'lspsaga'.init_lsp_saga {
  use_saga_diagnostic_sign = true,
  error_sign = s.error,
  warn_sign = s.warning,
  infor_sign = s.info,
  hint_sign = s.question,
  diagnostic_header_icon = '  ',
  use_diagnostic_virtual_text = false,
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
