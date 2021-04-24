" Colorscheme build in Lua with `lush.nvim`, modeled initially on Solarized, but intended to be
" usable with alternate colors.
" Still early days, with lots of work needed
" See `../lua/malo-theme.lua`
let g:colors_name = 'malo'

" Load colorscheme
lua require'malo.theme'.loadColorscheme()
