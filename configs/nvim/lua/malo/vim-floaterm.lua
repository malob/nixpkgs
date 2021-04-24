local utils = require 'malo.utils'

-- Floating terminal
-- https://github.com/voldikss/vim-floaterm
-- Plugin loaded on first use of keybinding
vim.g.floaterm_title       = 'Terminal ($1/$2)'
vim.g.floaterm_borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' }
vim.g.floaterm_width       = 0.8
vim.g.floaterm_height      = 0.8

function FloatTermKeymaps ()
  utils.bufkeymaps { mode = '',  opts = { 'silent' }, maps = {
    { '<Space>tn' , ':FloatermNew<CR>'    },
    { '<Space>tl' , ':FloatermNext<CR>'   },
    { '<Space>th' , ':FloatermPrev<CR>'   },
    { '<Space>tq' , ':FloatermKill<CR>'   },
    { '<ESC>'     , ':FloatermToggle<CR>' },
  }}
end

utils.augroup { name = 'FloatTermKeyMaps', cmds = {
  { 'FileType', 'floaterm', 'lua FloatTermKeymaps()' }
}}