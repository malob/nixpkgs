local keymaps = require'malo.utils'.keymaps

-- coq_nvim
-- https://github.com/ms-jpq/coq_nvim
vim.g.coq_settings = {
  auto_start = 'shut-up',
  xdg = true,

  clients = {
    tabnine = {
      enabled = true,
    }
  }
}

vim.cmd 'packadd coq_nvim'

require 'coq_3p' {
  { src = 'copilot', short_name = 'COP', accept_key = '<c-f>' }
}
