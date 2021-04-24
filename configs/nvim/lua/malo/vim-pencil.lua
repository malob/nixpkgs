-- vim-pencil
-- Adds a bunch of really nice features for writing
-- https://github.com/reedes/vim-pencil
vim.cmd 'packadd vim-pencil'

vim.g['pencil#wrapModeDefault'] = 'soft' -- default is 'hard'
require'malo.utils'.augroup { name = 'Pencil', cmds = {
  { 'FileType', 'markdown,mkd,text', 'call pencil#init() | setlocal spell' }
}}