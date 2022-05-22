local utils = require'malo.utils'

-- Floating terminal
-- https://github.com/voldikss/vim-floaterm
-- Plugin loaded on first use of keybinding
vim.g.floaterm_title       = 'Terminal ($1/$2)'
vim.g.floaterm_borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' }
vim.g.floaterm_width       = 0.8
vim.g.floaterm_height      = 0.8

utils.augroup { name = 'FloatTermKeymaps', cmds = {
  { 'FileType', {
    pattern = 'floaterm',
    desc = 'Load floating terminal keymaps.',
    callback = function ()
      utils.keymaps { modes = '', opts = { buffer = true, silent = true }, maps = {
        { ' tn'  , '<Cmd>FloatermNew<CR>'    },
        { ' tl'  , '<Cmd>FloatermNext<CR>'   },
        { ' th'  , '<Cmd>FloatermPrev<CR>'   },
        { ' tq'  , '<Cmd>FloatermKill<CR>'   },
        { '<ESC>', '<Cmd>FloatermToggle<CR>' },
      }}
    end
  }},
}}

