local g = vim.g
local o = vim.o

-- Most filetypes
-- vim-polyglot
-- A solid language pack for Vim
-- https://github.com/sheerun/vim-polyglot
vim.cmd 'packadd vim-polyglot'

-- Haskell
-- haskell-vim (comes in vim-polyglot)
-- https://github.com/neovimhaskell/haskell-vim.git
-- indenting options
g.haskell_indent_if = 3
g.haskell_indent_case = 2
g.haskell_indent_let = 4
g.haskell_indent_where = 6
g.haskell_indent_before_where = 2
g.haskell_indent_after_bare_where = 2
g.haskell_indent_do = 3
g.haskell_indent_in = 1
g.haskell_indent_guard = 2
-- turn on extra highlighting
g.haskell_backpack = 1
g.haskell_enable_arrowsyntax = 1
g.haskell_enable_quantification = 1
g.haskell_enable_recursivedo = 1
g.haskell_enable_pattern_synonyms = 1
g.haskell_enable_static_pointers = 1
g.haskell_enable_typeroles = 1

-- Javascript
-- vim-javascript (comes in vim-polyglot)
-- https://github.com/pangloss/vim-javascript
g.javascript_plugin_jsdoc = 1

-- Markdown
-- vim-markdown (comes in vim-polyglot)
-- https://github.com/plasticboy/vim-markdown
g.vim_markdown_folding_disabled = 1
g.vim_markdown_new_list_item_indent = 2
o.conceallevel = 2