-- coq_nvim
-- https://github.com/ms-jpq/coq_nvim

vim.g.coq_settings = {
  auto_start = 'shut-up',
  xdg = true,

  clients = {
    tabnine = {
      enabled = true,
    },
  },
  display = {
    preview = {
      border = 'shadow',
    },
  },
  limits = {
    completion_auto_timeout = 0.5,
  },
  match = {
    max_results = 100,
  },
}

vim.cmd 'packadd coq_nvim'

require 'coq_3p' {
  { src = 'copilot', short_name = 'COP', accept_key = '<c-f>' }
}
