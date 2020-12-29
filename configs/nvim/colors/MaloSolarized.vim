" Solarized inspired colorscheme build in Lua with `lush.nvim`, according to my taste
" Still early days, with lots of work needed
" https://github.com/rktjmp/lush.nvim
let g:colors_name = 'MaloSolarized'
lua require'lush'(require'MaloSolarized'.getParsedLushSpec())
