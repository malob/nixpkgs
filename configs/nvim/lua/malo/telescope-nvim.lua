-- telescope.nvim
-- https://github.com/nvim-telescope/telescope.nvim

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
  extensions = {
    file_browser = {
      hijack_netrw = true,
    },
  },
}

telescope.load_extension 'builtin_extensions'
telescope.load_extension 'file_browser'
telescope.load_extension 'fzf'
telescope.load_extension 'hoogle'
telescope.load_extension 'zoxide'

require'telescope._extensions.zoxide.config'.setup {
  mappings = {
    ['<CR>'] = {
      keepinsert = true,
      action = function(selection)
        telescope.extensions.file_browser.file_browser { cwb = selection.path }
      end
    },
  },
}
