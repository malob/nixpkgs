set encoding=utf-8
scriptencoding utf-8

" ================
" BASIC VIM CONFIG
" ================

let mapleader = '`'
let timeouttlen = 2000 " extend timout on leader key
set updatetime=100     " number of ms before changes are writted to swp file
set mouse=a            " enable mouse support for neovim
set inccommand=nosplit " enable preview while doing find and replace
set autochdir          " change working dir to dir of file in buffer
filetype plugin indent on

" Tab key behavior
set expandtab 	 " Convert tabs to spaces
set tabstop=2
set shiftwidth=2


" ====================
" UI/APPEARENCE CONFIG
" ====================

" Setup color scheme
" https://github.com/icymind/NeoSolarized
set termguicolors        " truecolor support
colorscheme NeoSolarized    " Solazized theme
set background=dark      " use dark version of colorscheme

" Other misc basic vim ui config
set cursorline  " highlight current line
set linebreak   " soft wraps on words not individual chars
set noshowmode  " don't show --INSERT-- etc.

" GitGutter
" https://github.com/airblade/vim-gitgutter
let g:gitgutter_override_sign_column_highlight = 0     " make sign column look consistent
let g:gitgutter_sign_added = '┃'                       " replace default symbols with something nicer
let g:gitgutter_sign_modified = g:gitgutter_sign_added
let g:gitgutter_sign_removed = g:gitgutter_sign_added

" denite.vim
" Powerful list searcher
" https://github.com/Shougo/denite.nvim
noremap <silent> <leader><space> :Denite source<CR>
noremap <silent> <leader>db  :Denite buffer<CR>
noremap <silent> <leader>dc  :Denite command<CR>
noremap <silent> <leader>dh  :Denite help<CR>
noremap <silent> <leader>dff :Denite file<CR>
noremap <silent> <leader>dfr :Denite file/rec<CR>


" ==============
" AIRLINE CONFIG
" ==============
" https://github.com/vim-airline/vim-airline

" General configuration
let g:airline_theme = 'solarized'
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]' " don't show file encoding unless it's something unexpected
let g:airline#extensions#hunks#non_zero_only = 1             " don't show git change stats unless there are some
let g:airline_skip_empty_sections = 1                        " don't show sections if they're empty

" Tabline configuration
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#tab_nr_type = 2        " tabs show [number of tab].[number of splits]
let g:airline#extensions#tabline#show_tab_type = 0      " don't show tab or buffer labels in bar
let g:airline#extensions#tabline#show_close_button = 0  " don't display close button in top right

" Extensions
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1

" Cutomtomize symbols
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.notexists = ' '
let g:airline_mode_map = {
  \ '__' : '-',
  \ 'n'  : 'N',
  \ 'i'  : '',
  \ 'R'  : 'R',
  \ 'c'  : '',
  \ 'v'  : '',
  \ 'V'  : '',
  \ ''   : '',
  \ 's'  : 'S',
  \ 'S'  : 'S',
  \ '' : 'S',
  \ 't'  : '',
  \ }


" ====================
" TAB AND PANES CONFIG
" ====================

" Make using terminal less crazy making
tnoremap <ESC> <C-\><C-n> " use ESC to enter normal mode in terminal
augroup neovimTerm " enable signcolumn and line numbers in all buffers except terminal
  au TermOpen * if &buftype == 'terminal' | :set nonumber | :set signcolumn=no  | :startinsert | endif
  au BufEnter * if &buftype != 'terminal' | :set number   | :set signcolumn=yes | endif
  au TabNewEntered * Startify
augroup END

" Startify
" Start screen configuration
" https://github.com/mhinz/vim-startify
let g:startify_update_oldfiles = 1
let g:startify_relative_path   = 1
let g:startify_fortune_use_unicode = 1
let g:startify_files_number = 7
let g:startify_lists = [
\ {'type': 'files',     'header': ['    🕘  Recent']              },
\ {'type': 'dir',       'header': ['    🕘  Recent in '. getcwd()]},
\ {'type': 'bookmarks', 'header': ['    🔖  Bookmarks']           },
\ {'type': 'commands',  'header': ['    🔧  Commands']            }
\ ]

let g:startify_bookmarks = [
\ {'n': '~/.config/nixpkgs/overlays/neovim-config.vim'},
\ {'f': '~/.config/fish/config.fish'  },
\ {'k': '~/.config/kitty/kitty.conf'  }
\ ]

let g:startify_commands = [
\ {'t': ['Open Terminal',  'term']},
\ ]

" vim-choosewin
" mimic tmux's display-pane feature
" https://github.com/t9md/vim-choosewin
nmap - <Plug>(choosewin)
let g:choosewin_label = 'TNERIAODH'   " alternating on homerow (colemak) 'S' is left out on purpose since it's used by choosewin
let g:choosewin_tabline_replace = 0   " turned off since tabs have numbers
" colors taken from NeoSolarized theme
let g:choosewin_color_label =         {'gui': ['#719e07', '#fdf6e3', 'bold'], 'cterm': [2 , 15, 'bold']}
let g:choosewin_color_label_current = {'gui': ['#657b83', '#002b36'],         'cterm': [10, 8 ]        }
let g:choosewin_color_other =         {'gui': ['#657b83', '#657b83'],         'cterm': [10, 10]        }
let g:choosewin_color_land =          {'gui': ['#b58900', '#002b36'],         'cterm': [3 , 8 ]        }

" Tab creation/destruction
" new tab w/ terminal
noremap  <silent> <leader>t <ESC>:tabnew<CR>
noremap! <silent> <leader>t <ESC>:tabnew<CR>
tnoremap <silent> <leader>t <C-\><C-n>:tabnew<CR>
" close tab
noremap  <silent> <leader>x <ESC>:tabclose<CR>
noremap! <silent> <leader>x <ESC>:tabclose<CR>
tnoremap <silent> <leader>x <C-\><C-n>:tabclose<CR>

" Tab navigation
" next tab
noremap  <silent> <leader>n <ESC>:tabnext<CR>
noremap! <silent> <leader>n <ESC>:tabnext<CR>
tnoremap <silent> <leader>n <C-\><C-n>:tabnext<CR>
" previous tab
noremap  <silent> <leader>p <ESC>:tabprevious<CR>
noremap! <silent> <leader>p <ESC>:tabprevious<CR>
tnoremap <silent> <leader>p <C-\><C-n>:tabprevious<CR>

" Pane creation/destruction
" new verticle split w/ terminal
noremap  <silent> <leader>\| <ESC>:vs +term<CR>
noremap! <silent> <leader>\| <ESC>:vs +term<CR>
tnoremap <silent> <leader>\| <C-\><C-n>:vs +term<CR>
" new horizontal split w/ terminal
noremap  <silent> <leader>_ <ESC>:split +term<CR>
noremap! <silent> <leader>_ <ESC>:split +term<CR>
tnoremap <silent> <leader>_ <C-\><C-n>:split +term<CR>
" close pane
noremap  <silent> <leader>q <ESC>:q<CR>
noremap! <silent> <leader>q <ESC>:q<CR>
tnoremap <silent> <leader>q <C-\><C-n>:q<CR>

" Pane navigation
" move left
noremap  <silent> <leader>h <ESC>:wincmd h<CR>
noremap! <silent> <leader>h <ESC>:wincmd h<CR>
tnoremap <silent> <leader>h <C-\><C-n><C-w>h
" move right
noremap  <silent> <leader>l <ESC>:wincmd l<CR>
noremap! <silent> <leader>l <ESC>:wincmd l<CR>
tnoremap <silent> <leader>l <C-\><C-n><C-w>l
" move up
noremap  <silent> <leader>k <ESC>:wincmd k<CR>
noremap! <silent> <leader>k <ESC>:wincmd k<CR>
tnoremap <silent> <leader>k <C-\><C-n><C-w>k
" move down
noremap  <silent> <leader>j <ESC>:wincmd j<CR>
noremap! <silent> <leader>j <ESC>:wincmd j<CR>
tnoremap <silent> <leader>j <C-\><C-n><C-w>j

" Close various special panes
" help
noremap <silent> <leader>ch :helpclose<CR>
" preview
noremap <silent> <leader>cp :pclose<CR>


" ======================
" LANGUAGE SERVER CONFIG
" ======================
" LanguageClient-neovim
" Provides completions, linting, fixers, etc.
" https://github.com/autozimu/LanguageClient-neovim

let g:LanguageClient_serverCommands = {
\ 'sh': ['/usr/local/bin/bash-language-server', 'start'],
\ 'haskell': ['hie-wrapper'],
\ 'javascript': ['/usr/local/bin/typescript-language-server', '--stdio'],
\ 'lua': ['/usr/local/bin/lua-lsp'],
\ 'typescript': ['/usr/local/bin/typescript-language-server', '--stdio'],
\ }
let g:LanguageClient_rootMarkers = {
\ 'haskell': ['*.cabal', 'stack.yaml'],
\ }

" Customize symbols
let g:LanguageClient_diagnosticsDisplay = {
\ 1: {
\     'name': 'Error',
\     'texthl': 'ALEError',
\     'signText': '',
\     'signTexthl': 'ALEErrorSign',
\ },
\ 2:  {
\     'name': 'Warning',
\     'texthl': 'ALEWarning',
\     'signText': '',
\     'signTexthl': 'ALEWarningSign',
\ },
\ 3:  {
\     'name': 'Information',
\     'texthl': 'ALEInfo',
\     'signText': '\uF05A',
\     'signTexthl': 'ALEInfoSign',
\ },
\ 4:  {
\     'name': 'Hint',
\     'texthl': 'ALEInfo',
\     'signText': '➤',
\     'signTexthl': 'ALEInfoSign',
\ },
\ }

" Automatically invoke hover and highlight on cursor movement
" https://github.com/autozimu/LanguageClient-neovim/issues/618#issuecomment-424539982
let g:LanguageClient_hoverPreview = 'Always' " Always show preview window

function! LspMaybeHover(is_running) abort
  if a:is_running.result
    call LanguageClient_textDocument_hover()
  endif
endfunction

function! LspMaybeHighlight(is_running) abort
  if a:is_running.result
    call LanguageClient#textDocument_documentHighlight()
  endif
endfunction

augroup lsp_aucommands
  au!
  au CursorHold * call LanguageClient#isAlive(function('LspMaybeHover'))
  au CursorMoved * call LanguageClient#isAlive(function('LspMaybeHighlight'))
augroup END


"===========
" ALE CONFIG
"===========
" Asyncronous Linting Engine
" Used for linting when no good language server is available
" https://github.com/w0rp/ale

" Commands to install bins required for linters/fixes
" javascript/json: npm i -g prettier prettier-eslint
" puppet: gem install puppet-lint
" vim: pip install vim-vint

" Disable linters for filetypes with language servers
let g:ale_linters = {
\ 'sh': [],
\ 'haskell': [],
\ 'javascript': [],
\ 'lua': [],
\ 'typescript': []
\ }

" Enable some fixers
let g:ale_fixers = {
\ '*': ['remove_trailing_lines', 'trim_whitespace'],
\ 'javascript': ['prettier-eslint'],
\ 'json': ['prettier'],
\ 'puppet': ['puppetlint']
\ }
let g:ale_fix_on_save = 1

" Customize symbols
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_sign_info = "\uF05A"
let g:ale_sign_style_error = "\uF8EA"
let g:ale_sign_style_warning = g:ale_sign_style_error


" =================
" COMPLETION CONFIG
" =================

" Deoplete autocompletion engine
" Used to display/manage all completions
" https://github.com/Shougo/deoplete.nvim
let g:deoplete#enable_at_startup = 1
augroup deoplete
au VimEnter * call deoplete#custom#var('around', {
\ 'mark_above': '[↑]',
\ 'mark_below': '[↓]',
\ 'mark_changes': '[*]',
\ })
augroup END

" Use tab to navigate completion menu
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" neco-vim
" Deoplete completion source for vim files
" https://github.com/Shougo/neco-vim

" deoplete-fish
" Deoplete completion source for fish files
" https://github.com/ponko2/deoplete-fish


" ==================
" LANGUAGE SHORTCUTS
" ==================

nnoremap <leader>lh :call LanguageClient#textDocument_hover()<CR>
nnoremap <leader>ld :call LanguageClient#textDocument_definition({'gotoCmd': 'split'})<CR>
nnoremap <leader>li :call LanguageClient#textDocument_implementation()<CR>
nnoremap <leader>lr :call LanguageClient#textDocument_rename()<CR>
nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>
nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
nnoremap <leader>la :call LanguageClient#workspace_applyEdit()<CR>
nnoremap <leader>ll :call LanguageClient#textDocument_documentHighlight()<CR>
nnoremap <leader>lc :Denite codeAction<CR>
nnoremap <leader>lm :Denite contextMenu<CR>
nnoremap <leader>ls :Denite documentSymbol<CR>
nnoremap <leader>lw :Denite workspaceSymbol<CR>
nnoremap <leader>lx :Denite references<CR>

nnoremap <leader>en :cnext<CR>
nnoremap <leader>ep :cprev<CR>


" ===========================
" WRITING AND MARKDOWN CONFIG
" ===========================

" vim-markdown
" Adds a ton of functionality for Markdown
" https://github.com/plasticboy/vim-markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_new_list_item_indent = 2
set conceallevel=2

" vim-pencil
" Adds a bunch of really nice features for writing
" https://github.com/reedes/vim-pencil
let g:pencil#wrapModeDefault = 'soft'   " default is 'hard'
let g:airline_section_x = '%{PencilMode()}'
augroup pencil
  autocmd!
  autocmd FileType markdown,mkd call pencil#init()
  autocmd FileType text         call pencil#init()
augroup END

" tabular
" Helps vim-markdown with table formatting amoung other things
" https://github.com/godlygeek/tabular
"
" Goyo
" Distraction free writing mode for vim
" https://github.com/junegunn/goyo.vim


" ============================
" PROGRAMMING LANGUAGE PLUGINS
" ============================

" vim-javascript
" Syntax highlighting for js
" https://github.com/pangloss/vim-javascript
let g:javascript_plugin_jsdoc = 1

" yats.vim
" Syntax highlighting for TypeScript
" https://github.com/herringtondarkholme/yats.vim

" vim-fish
" Syntax highlighting and a bunch of other stuff for Fish
" https://github.com/dag/vim-fish

" haskell-vim
" Syntax highlighting and indentation for Haskell
" https://github.com/neovimhaskell/haskell-vim.git
" indenting options
let g:haskell_indent_if = 3
let g:haskell_indent_case = 2
let g:haskell_indent_let = 4
let g:haskell_indent_where = 6
let g:haskell_indent_before_where = 2
let g:haskell_indent_after_bare_where = 2
let g:haskell_indent_do = 3
let g:haskell_indent_in = 1
let g:haskell_indent_guard = 2
" turn on extra highlighting
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
