" vim: foldmethod=marker
scriptencoding=utf-8

" BASIC VIM CONFIG {{{
" ================

let mapleader = '`'
let timeouttlen = 2000 " extend timout on leader key
set updatetime=100     " number of ms before changes are writted to swp file
set mouse=a            " enable mouse support for neovim
set autochdir          " change working dir to dir of file in buffer

" Search
set smartcase          " search is case sensitive only if it containts uppercase chars
set inccommand=nosplit " show preview in buffer while doing find and replace

" Tab key behavior
set expandtab 	 " Convert tabs to spaces
set tabstop=2    " Width of tab character
set shiftwidth=2 " Width of autoindets

" Setup color scheme
" https://github.com/icymind/NeoSolarized
set termguicolors        " truecolor support
colorscheme NeoSolarized " version of solarized that works better with truecolors
let g:neosolarized_italic = 1

" Misc basic vim ui config
set cursorline            " highlight current line
set linebreak             " soft wraps on words not individual chars
set noshowmode            " don't show --INSERT-- etc.
set colorcolumn=100       " show column boarder
set number relativenumber " relative line numbers
set signcolumn=yes

" Enable signcolumn and line numbers in all buffers except terminal
" augroup signNumColumn
"   au TermOpen * if &buftype == 'terminal' | :set nonumber | :set signcolumn=no  | endif
"   au BufEnter * if &buftype != 'terminal' | :set number   | :set signcolumn=yes | endif
" augroup END
" }}}

" STATUS LINE CONFIG {{{
" ==================
" https://github.com/vim-airline/vim-airline

" General configuration
let g:airline_theme = 'solarized'
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]' " only show unusual file encoding
let g:airline#extensions#hunks#non_zero_only = 1             " only git stats when there are changes
let g:airline_skip_empty_sections = 1                        " don't show sections if they're empty

" Tabline configuration
let g:airline#extensions#tabline#enabled = 1            " needed since it isn't on by default
let g:airline#extensions#tabline#show_buffers = 0       " don't show buffers in tabline
let g:airline#extensions#tabline#show_tabs = 1          " show tabs in tabline
let g:airline#extensions#tabline#show_splits = 0        " don't number of splits
let g:airline#extensions#tabline#tab_nr_type = 2        " tabs show [tab num].[num of splits in tab]
let g:airline#extensions#tabline#show_tab_type = 0      " don't show tab or buffer labels in bar
let g:airline#extensions#tabline#show_close_button = 0  " don't display close button in top right

" Cutomtomize symbols
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.notexists = ''
let g:airline_mode_map = {
\ '__' : '-',
\ 'c'  : '',
\ 'i'  : '',
\ 'ic' : 'I',
\ 'ix' : 'I',
\ 'n'  : '',
\ 'ni' : 'N',
\ 'no' : 'N',
\ 'R'  : 'R',
\ 'Rv' : 'R',
\ 's'  : 'S',
\ 'S'  : 'S',
\ '' : 'S',
\ 't'  : '',
\ 'v'  : '',
\ 'V'  : ' LINE',
\ '' : ' BLOCK',
\ }

" Extensions configuration
let airline#extensions#ale#error_symbol = ':'
let airline#extensions#ale#warning_symbol = ':'
let airline#extensions#languageclient#error_symbol = ':'
let airline#extensions#languageclient#warning_symbol = ':'
let g:airline#extensions#quickfix#quickfix_text = ''
let g:airline#extensions#quickfix#location_text = ''
" }}}

" WELCOME SCREEN CONFIG {{{
" =====================

" Startify
" Start screen configuration
" https://github.com/mhinz/vim-startify
let g:startify_files_number = 7         " max number of files/dirs in lists
let g:startify_relative_path = 1        " use relative path if file is below current directory
let g:startify_update_oldfiles = 1      " update old file list whenever Startify launches
let g:startify_fortune_use_unicode = 1  " use unicode rather than ASCII in fortune

" Define Startify lists
let g:startify_lists = [
\ {'type': 'files',     'header': ['    🕘  Recent']              },
\ {'type': 'dir',       'header': ['    🕘  Recent in '. getcwd()]},
\ {'type': 'bookmarks', 'header': ['    🔖  Bookmarks']           },
\ {'type': 'commands',  'header': ['    🔧  Commands']            },
\ ]

" Define bookmarks and commands
" Remember that Startify uses e, i, q, b, s, v, and t.
let g:startify_bookmarks = [
\ {'n': '~/.config/nixpkgs/overlays/neovim-config.vim'},
\ {'k': '~/.config/nixpkgs/overlays/kitty.conf'       },
\ {'f': '~/.config/fish/config.fish'                  },
\ ]
let g:startify_commands = [
\ {'t': ['Open Terminal',  'term']},
\ {'r': ['Rebuild Nix User',
  \ 'let nixRubuildOutput=system("nixuser-rebuild") |
  \ let newVimConfig=system("nix-store --query --references (which nvim) | grep vimrc") |
  \ execute "source" newVimConfig |
  \ redraw |
  \ echo nixRubuildOutput'
\ ]},
\ ]

" Run Startify in new tabs
" See keyboard shortcuts in next section
" }}}

" WINDOW/SPLITS/TABS/TERMINAL CONFIG {{{
" ==================================

" Use ESC to enter normal mode in terminal
tnoremap <ESC> <C-\><C-n>

" Start new terminals in insert mode
augroup nvimTerm
  au TermOpen * if &buftype == 'terminal' | :startinsert | endif
augroup END

" vim-choosewin
" mimic tmux's display-pane feature
" https://github.com/t9md/vim-choosewin
nmap - <Plug>(choosewin)
let g:choosewin_label = 'TNERIAODH'   " alternating on homerow for colemak (choosewin uses 'S')
let g:choosewin_tabline_replace = 0   " don't use choosewin tabline since Airline provides numbers

" Style choosewin to fit in with NeoSolarized colorscheme
let g:choosewin_color_label =         {'gui': ['#719e07', '#fdf6e3', 'bold'], 'cterm': [2 , 15, 'bold']}
let g:choosewin_color_label_current = {'gui': ['#657b83', '#002b36'],         'cterm': [10, 8 ]        }
let g:choosewin_color_other =         {'gui': ['#657b83', '#657b83'],         'cterm': [10, 10]        }
let g:choosewin_color_land =          {'gui': ['#b58900', '#002b36'],         'cterm': [3 , 8 ]        }

" Set where splits open
set splitbelow " open horizontal splits below instead of above which is the default
set splitright " open vertical splits to the right instead of the left with is the default

" Tab creation/destruction
" new tab w/ Startify
noremap  <silent> <leader>tt <ESC>:tabnew +Startify<CR>
inoremap <silent> <leader>tt <ESC>:tabnew +Startify<CR>
tnoremap <silent> <leader>tt <C-\><C-n>:tabnew +Startify<CR>
" close tab
noremap  <silent> <leader>tq <ESC>:tabclose<CR>
tnoremap <silent> <leader>tq <C-\><C-n>:tabclose<CR>

" Tab navigation
" next tab
noremap  <silent> <leader>tn <ESC>:tabnext<CR>
inoremap <silent> <leader>tn <ESC>:tabnext<CR>
tnoremap <silent> <leader>tn <C-\><C-n>:tabnext<CR>
" previous tab
noremap  <silent> <leader>tp <ESC>:tabprevious<CR>
inoremap <silent> <leader>tp <ESC>:tabprevious<CR>
tnoremap <silent> <leader>tp <C-\><C-n>:tabprevious<CR>

" Split creation/destruction
" new horizontal split w/ terminal
noremap  <silent> <leader>-  <ESC>:new +term<CR>
inoremap <silent> <leader>-  <ESC>:new +term<CR>
tnoremap <silent> <leader>-  <C-\><C-n>:new +term<CR>
" new vertical split w/ terminal
noremap  <silent> <leader>\ <ESC>:vnew +term<CR>
inoremap <silent> <leader>\ <ESC>:vnew +term<CR>
tnoremap <silent> <leader>\ <C-\><C-n>:vnew +term<CR>
" new full width horizontal split w/ terminal
noremap  <silent> <leader>_  <ESC>:botright new +term<CR>
inoremap <silent> <leader>_  <ESC>:botright new +term<CR>
tnoremap <silent> <leader>_  <C-\><C-n>:botright new +term<CR>
" new full height vertical split w/ terminal
noremap  <silent> <leader>\| <ESC>:botright vnew +term<CR>
inoremap <silent> <leader>\| <ESC>:botright vnew +term<CR>
tnoremap <silent> <leader>\| <C-\><C-n>:botright vnew +term<CR>
" close split/window
noremap  <silent> <leader>qq <ESC>:q<CR>
inoremap <silent> <leader>qq <ESC>:q<CR>
tnoremap <silent> <leader>qq <C-\><C-n>:q<CR>
" close vim
noremap  <silent> <leader>qa <ESC>:qa<CR>
inoremap <silent> <leader>qa <ESC>:qa<CR>
tnoremap <silent> <leader>qa <C-\><C-n>:qa<CR>

" Split navigation
" move left
noremap  <silent> <leader>h <ESC>:wincmd h<CR>
inoremap <silent> <leader>h <ESC>:wincmd h<CR>
tnoremap <silent> <leader>h <C-\><C-n><C-w>h
" move right
noremap  <leader>l <ESC>:wincmd l<CR>
inoremap <silent> <leader>l <ESC>:wincmd l<CR>
tnoremap <silent> <leader>l <C-\><C-n><C-w>l
" move up
noremap  <silent> <leader>k <ESC>:wincmd k<CR>
inoremap <silent> <leader>k <ESC>:wincmd k<CR>
tnoremap <silent> <leader>k <C-\><C-n><C-w>k
" move down
noremap  <silent> <leader>j <ESC>:wincmd j<CR>
inoremap <silent> <leader>j <ESC>:wincmd j<CR>
tnoremap <silent> <leader>j <C-\><C-n><C-w>j

" Close/open various special splits
" close help
noremap  <silent> <leader>qh <ESC>:helpclose<CR>
inoremap <silent> <leader>qh <ESC>:helpclose<CR>
tnoremap <silent> <leader>qh <C-\><C-n>:helpclose<CR>
" close preview
noremap  <silent> <leader>qp <ESC>:pclose<CR>
inoremap <silent> <leader>qp <ESC>:pclose<CR>
tnoremap <silent> <leader>qp <C-\><C-n>:pclose<CR>
" open quickfix list
noremap  <silent> <leader>oc <ESC>:copen<CR>
inoremap <silent> <leader>oc <ESC>:copen<CR>
tnoremap <silent> <leader>oc <C-\><C-n>:copen<CR>
" close quickfix list
noremap  <silent> <leader>qc <ESC>:cclose<CR>
inoremap <silent> <leader>qc <ESC>:cclose<CR>
tnoremap <silent> <leader>qc <C-\><C-n>:cclose<CR>
" }}}

" LANGUAGE SERVER CONFIG {{{
" ======================
" LanguageClient-neovim
" Provides completions, linting, fixers, etc.
" https://github.com/autozimu/LanguageClient-neovim

let g:LanguageClient_settingsPath = '.vim/settings.json'

" Point language client as some language servers
let g:LanguageClient_serverCommands = {
\ 'c':          ['ccls'],
\ 'cpp':        ['ccls'],
\ 'sh':         ['bin/bash-language-server', 'start'],
\ 'haskell':    ['hie'],
\ 'javascript': ['typescript-language-server', '--stdio'],
\ 'lua':        ['lua-lsp'],
\ 'typescript': ['typescript-language-server', '--stdio'],
\ }

" Help some language servers find project roots
let g:LanguageClient_rootMarkers = {
\ 'haskell': ['stack.yaml', '*.cabal'],
\ }

" Customize symbols
let g:LanguageClient_diagnosticsDisplay = {
\ 1: {
  \ 'name':       'Error',
  \ 'texthl':     'ALEError',
  \ 'signText':   '',
  \ 'signTexthl': 'ALEErrorSign',
\ },
\ 2: {
  \ 'name':       'Warning',
  \ 'texthl':     'ALEWarning',
  \ 'signText':   '',
  \ 'signTexthl': 'ALEWarningSign',
\ },
\ 3: {
  \ 'name':       'Information',
  \ 'texthl':     'ALEInfo',
  \ 'signText':   '',
  \ 'signTexthl': 'ALEInfoSign',
\ },
\ 4: {
  \ 'name':       'Hint',
  \ 'texthl':     'ALEInfo',
  \ 'signText':   '➤',
  \ 'signTexthl': 'ALEInfoSign',
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
  au CursorHold  * call LanguageClient#isAlive(function('LspMaybeHover'))
  au CursorMoved * call LanguageClient#isAlive(function('LspMaybeHighlight'))
augroup END

" Language server related shortcuts
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
" }}}

" LINTER/FIXER CONFIG {{{
" =======================
" Asyncronous Linting Engine (ALE)
" Used for linting when no good language server is available
" https://github.com/w0rp/ale

" Disable linters for languges that have defined language servers above
let g:ale_linters = {
\ 'c': [],
\ 'sh': [],
\ 'haskell': [],
\ 'javascript': [],
\ 'lua': [],
\ 'typescript': []
\ }

" Configure and enable fixer
let g:ale_fix_on_save = 1
let g:ale_fixers = {
\ '*':          ['remove_trailing_lines', 'trim_whitespace'],
\ 'javascript': ['prettier-eslint'],
\ 'json':       ['prettier'],
\ 'puppet':     ['puppetlint']
\ }

" Customize symbols
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_sign_info = ''
let g:ale_sign_style_error = ''
let g:ale_sign_style_warning = g:ale_sign_style_error
" }}}

" COMPLETION CONFIG {{{
" =====================
" Deoplete autocompletion engine
" Used to display/manage all completions including those from language servers
" https://github.com/Shougo/deoplete.nvim
let g:deoplete#enable_at_startup = 1
augroup deoplete
  au BufEnter * call deoplete#custom#var('around', {
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
" }}}

" WRITING AND MARKDOWN CONFIG {{{
" ===============================

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
  au!
  au FileType markdown,mkd call pencil#init()
  au FileType text         call pencil#init()
augroup END

" tabular
" Helps vim-markdown with table formatting amoung other things
" https://github.com/godlygeek/tabular
"
" Goyo
" Distraction free writing mode for vim
" https://github.com/junegunn/goyo.vim
" }}}

" MISC PLUGIN CONFIG {{{
" ======================

" denite.vim
" Powerful list searcher
" https://github.com/Shougo/denite.nvim
noremap <silent> <leader><space> :Denite source<CR>
noremap <silent> <leader>db      :Denite buffer<CR>
noremap <silent> <leader>dc      :Denite command<CR>
noremap <silent> <leader>dh      :Denite help<CR>
noremap <silent> <leader>dff     :Denite file<CR>
noremap <silent> <leader>dfr     :Denite file/rec<CR>

" GitGutter
" https://github.com/airblade/vim-gitgutter
let g:gitgutter_override_sign_column_highlight = 0     " make sign column look consistent
let g:gitgutter_sign_added = '┃'                       " replace default symbols with something nicer
let g:gitgutter_sign_modified = g:gitgutter_sign_added
let g:gitgutter_sign_removed = g:gitgutter_sign_added

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
" }}}
