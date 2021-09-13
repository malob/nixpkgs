-- telescope.nvim
-- https://github.com/nvim-telescope/telescope.nvim
vim.cmd 'packadd telescope.nvim'
vim.cmd 'packadd telescope-symbols.nvim'
vim.cmd 'packadd telescope-z.nvim'

local telescope = require 'telescope'
local actions = require 'telescope.actions'
local previewers = require 'telescope.previewers'

telescope.setup {
  defaults = {
    prompt_prefix = '❯ ',
    selection_caret = '❯ ',
    color_devicons = true,
    file_previewer = previewers.vim_buffer_cat.new,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
    winblend = 10,
    mappings = {
      n = {
        ['<CR>'] = actions.select_default + actions.center,
        s = actions.select_horizontal,
        v = actions.select_vertical,
        t = actions.select_tab,
        j = actions.move_selection_next,
        k = actions.move_selection_previous,
        u = actions.preview_scrolling_up,
        d = actions.preview_scrolling_down,
      },
    },
  },
}

telescope.load_extension 'builtin_extensions'
telescope.load_extension 'z'
