" Solarized inspired colorscheme build in Lua with `lush.nvim`, according to my taste
" Still early days, with lots of work needed
" https://github.com/rktjmp/lush.nvim
let g:colors_name = 'MaloSolarized'

" Load colorscheme
lua require'lush'(require'MaloSolarized'.getParsedLushSpec())

" Set `nvim-web-devincons` highlights if they are in use
lua if pcall(require, 'nvim-web-devicons') then require'nvim-web-devicons'.setup() end
