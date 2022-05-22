local augroup = require'malo.utils'.augroup

-- vim-pencil
-- Adds a bunch of really nice features for writing
-- https://github.com/reedes/vim-pencil
vim.cmd 'packadd vim-pencil'

vim.g['pencil#wrapModeDefault'] = 'soft' -- default is 'hard'
augroup { name = 'MaloPencil', cmds = {
  { 'FileType', {
    pattern = { 'markdown', 'mkd', 'text' },
    desc = 'Enable Pencil for spell checking in markdown and text files.',
    callback = function() vim.fn['pencil#init'](); vim.wo.spell = true end,
  }}
}}
