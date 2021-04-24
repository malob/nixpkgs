local utils = require 'malo.utils'

-- completion-nvim
-- https://github.com/nvim-lua/completion-nvim
vim.cmd 'packadd completion-nvim'
vim.cmd 'packadd completion-buffers'
vim.cmd 'packadd completion-tabnine'

-- Recommended option settings
vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.shortmess   = vim.o.shortmess .. 'c' -- don't show extra message when using completion

-- Use <Tab> and <S-Tab> to navigate through popup menu
utils.keymaps { mode = 'i', opts = { 'noremap', 'expr' }, maps = {
  { '<Tab>'   , [[pumvisible() ? "\<C-n>" : "\<Tab>"]]   },
  { '<S-Tab>' , [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]] },
}}

-- How completions are sorted
vim.g.completion_sorting = 'length' -- possible value: "length", "alphabet", "none"
-- completion-nvim will loop through the list and assign priority from high to low
vim.g.completion_matching_strategy_list = { 'exact', 'substring', 'fuzzy', 'all' }
vim.g.completion_matching_smart_case    = 1
vim.g.completion_trigger_keyword_length = 3
vim.g.completion_trigger_on_delete      = 1

vim.g.completion_tabnine_max_num_results = 10

-- Specify which completiions are available
vim.g.completion_chain_complete_list = {
  { complete_items = { 'lsp', 'path', 'snippet', 'tabnine' } },
  { mode = '<C-p>' },
  { mode = '<C-n>' },
}

-- Use completion-nvim with every buffer
utils.augroup { name = 'Completions', cmds = {
  { 'BufEnter', '*', [[lua require'completion'.on_attach()]] },
}}
