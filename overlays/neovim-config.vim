" vim: foldmethod=marker
scriptencoding=utf-8

" COMMENTS AND CONTEXT {{{
" ====================
"
" Keyboard shortcut philosophy:
" * Don't change default shortcuts unless there a consistent model for the change.
" * Leader shortcuts are for commands that don't fit nicely into Vim's shortcut grammar.
"   * Avoid single key leader shortcuts. Have the first key be some mnemonic for what the command does.
"   * <leader>l for language server related commands.
"   * <leader>w for window related commands.
"   * <leader>/ for search (Denite) related commands.
"   * <leader>t for tab related commands.
"   * <leader>q for quit/close related commands.
" }}}

" BASIC VIM CONFIG {{{
" ================

let mapleader = '`'
let timeouttlen = 2000 " extend time-out on leader key
set updatetime=100     " number of ms before changes are written to swap file
set mouse=a            " enable mouse support for Neovim
set autochdir

" Search
set smartcase          " search is case sensitive only if it contains uppercase chars
set inccommand=nosplit " show preview in buffer while doing find and replace

" Tab key behavior
set expandtab 	 " Convert tabs to spaces
set tabstop=2    " Width of tab character
set shiftwidth=2 " Width of auto-indents

" Setup color scheme
" https://github.com/icymind/NeoSolarized
" terminal colors configured in ./neovim.nix
set termguicolors             " truecolor support
colorscheme NeoSolarized      " version of solarized that works better with truecolors
let g:neosolarized_italic = 1

" Misc basic vim ui config
set cursorline      " highlight current line
set linebreak       " soft wraps on words not individual chars
set noshowmode      " don't show --INSERT-- etc.
set colorcolumn=100 " show column boarder
set relativenumber  " relative line numbers
set signcolumn=yes  " always have signcolumn open to avoid thing shifting around all the time
set scrolloff=5     " start scrolling when cursor is within 5 lines of the edge

" Variables to reuse in config
let error_symbol  = ''
let warnin_symbol = ''
let info_symbol   = ''

" Check if file has changed on disk, if it has and buffer has no changes, relaod it
augroup checktime
  au!
  au BufEnter,FocusGained,CursorHold,CursorHoldI * checktime
augroup END

" Function to create mappings in all modes
function! Anoremap(arg, lhs, rhs)
  for map_command in ['noremap', 'noremap!', 'tnoremap']
    execute map_command a:arg a:lhs a:rhs
  endfor
endfunction
" }}}

" STATUS LINE {{{
" ===========
" https://github.com/vim-airline/vim-airline

" General configuration
let g:airline#parts#ffenc#skip_expected_string ='utf-8[unix]' " only show unusual file encoding
let g:airline#extensions#hunks#non_zero_only = 1              " only git stats when there are changes
let g:airline_skip_empty_sections = 1                         " don't show sections if they're empty

" Tabline configuration
let g:airline#extensions#tabline#enabled           = 1 " needed since it isn't on by default
let g:airline#extensions#tabline#show_tabs         = 1 " always show tabs in tabline
let g:airline#extensions#tabline#show_buffers      = 0 " don't show buffers in tabline
let g:airline#extensions#tabline#show_splits       = 0 " don't number of splits
let g:airline#extensions#tabline#tab_nr_type       = 2 " tabs show [tab num].[num of splits in tab]
let g:airline#extensions#tabline#show_tab_type     = 0 " don't show tab or buffer labels in bar
let g:airline#extensions#tabline#show_close_button = 0 " don't display close button in top right

" Cutomtomize symbols
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_symbols.branch    = ''
let g:airline_symbols.readonly  = ''
let g:airline_symbols.notexists = ''
let g:airline_symbols.dirty     = ''
let g:airline_mode_map =
\ { '__': '-'
\ , 'c' : ''
\ , 'i' : ''
\ , 'ic': 'I'
\ , 'ix': 'I'
\ , 'n' : ''
\ , 'ni': 'N'
\ , 'no': 'N'
\ , 'R' : 'R'
\ , 'Rv': 'R'
\ , 's' : 'S'
\ , 'S' : 'S'
\ , '': 'S'
\ , 't' : ''
\ , 'v' : ''
\ , 'V' : ' LINE'
\ , '': ' BLOCK'
\ }

" Extensions configuration
let airline#extensions#ale#error_symbol              = error_symbol  + ':'
let airline#extensions#ale#warning_symbol            = warnin_symbol + ':'
let airline#extensions#languageclient#error_symbol   = error_symbol  + ':'
let airline#extensions#languageclient#warning_symbol = warnin_symbol + ':'
let g:airline#extensions#quickfix#quickfix_text      = ''
let g:airline#extensions#quickfix#location_text      = ''
" }}}

" WELCOME SCREEN {{{
" ==============

" Startify
" Start screen configuration
" https://github.com/mhinz/vim-startify
let g:startify_files_number        = 7 " max number of files/dirs in lists
let g:startify_relative_path       = 1 " use relative path if file is below current directory
let g:startify_update_oldfiles     = 1 " update old file list whenever Startify launches
let g:startify_fortune_use_unicode = 1 " use unicode rather than ASCII in fortune

" Define Startify lists
let g:startify_lists =
\ [ {'type': 'files'    , 'header': ['    🕘  Recent']}
\ , {'type': 'dir'      , 'header': ['    🕘  Recent in '. getcwd()]}
\ , {'type': 'bookmarks', 'header': ['    🔖  Bookmarks']}
\ , {'type': 'commands' , 'header': ['    🔧  Commands']}
\ ]

" Define bookmarks and commands
" Remember that Startify uses h, j, k, l, e, i, q, b, s, v, and t.
let g:startify_bookmarks =
\ [ {'n': '~/.config/nixpkgs/overlays/neovim-config.vim'}
\ , {'f': '~/.config/fish/config.fish'}
\ ]
let g:startify_commands =
\ [ {'t': ['Open Terminal',  'term']}
\ , {'r':
\     [ 'Rebuild Nix User'
\     , ' let nixRubuildOutput=system("nixuser-rebuild")
\       | let newVimConfig=system("nix-store --query --references (which nvim) | grep vimrc")
\       | execute "source" newVimConfig
\       | redraw
\       | echo nixRubuildOutput
\       '
\     ]
\   }
\ ]

" Run Startify in new tabs
" See keyboard shortcuts in next section
" }}}

" WINDOW/SPLITS/TABS/TERMINAL {{{
" ===========================

" Make escape more sensible in terminal mode
tnoremap <ESC> <C-\><C-n>    " enter normal mode
tnoremap <leader><ESC> <ESC> " send escape to terminal

" Start new terminals in insert mode
augroup nvimTerm
  au TermOpen * if &buftype == 'terminal' | :startinsert | endif
augroup END

" vim-choosewin
" mimic tmux's display-pane feature
" https://github.com/t9md/vim-choosewin
" color setting in neovim.nix
call Anoremap('<silent>', '<leader><leader>', '<Cmd>ChooseWin<CR>')
let g:choosewin_label = 'TNERIAODH' " alternating on homerow for colemak (choosewin uses 'S')
let g:choosewin_tabline_replace = 0 " don't use choosewin tabline since Airline provides numbers

" Set where splits open
set splitbelow " open horizontal splits below instead of above which is the default
set splitright " open vertical splits to the right instead of the left with is the default

" Tab creation/destruction
call Anoremap('<silent>', '<leader>tt', '<Cmd>tabnew +Startify<CR>') " new tab w/ Startify
call Anoremap('<silent>', '<leader>qt', '<Cmd>tabclose<CR>')         " close tab

" Tab navigation
call Anoremap('<silent>', '<leader>tn', '<Cmd>tabnext<CR>')     " next tab
call Anoremap('<silent>', '<leader>tN', '<Cmd>tabprevious<CR>') " previous tab

" Split creation/destruction
call Anoremap('<silent>', '<leader>-' , '<Cmd>new +term<CR>')           " new horizontal split w/ terminal
call Anoremap('<silent>', '<leader>_' , '<Cmd>botright new +term<CR>')  " new full width horizontal split w/ terminal
call Anoremap('<silent>', '<leader>\' , '<Cmd>vnew +term<CR>')          " new vertical split w/ terminal
call Anoremap('<silent>', '<leader>\|', '<Cmd>botright vnew +term<CR>') " new full height vertical split w/ terminal
call Anoremap('<silent>', '<leader>qw', '<Cmd>q<CR>')                   " close split/window
call Anoremap('<silent>', '<leader>qa', '<Cmd>qa<CR>')                  " close vim

" Split navigation
call Anoremap('<silent>', '<leader>wh', '<Cmd>wincmd h<CR>') " move left
call Anoremap('<silent>', '<leader>wl', '<Cmd>wincmd l<CR>') " move right
call Anoremap('<silent>', '<leader>wk', '<Cmd>wincmd k<CR>') " move up
call Anoremap('<silent>', '<leader>wj', '<Cmd>wincmd j<CR>') " move down

" Close/open various special splits
call Anoremap('<silent>', '<leader>qh', '<Cmd>helpclose<CR>') " close help
call Anoremap('<silent>', '<leader>qp', '<Cmd>pclose<CR>')    " close preview
call Anoremap('<silent>', '<leader>oc', '<Cmd>copen<CR>')     " open quickfix list
call Anoremap('<silent>', '<leader>qc', '<Cmd>cclose<CR>')    " close quickfix list
" }}}

" LANGUAGE SERVER {{{
" ===============
" LanguageClient-neovim
" Provides completions, linting, fixers, etc.
" https://github.com/autozimu/LanguageClient-neovim

let g:LanguageClient_settingsPath = '.vim/settings.json'

" Point language client as some language servers
let g:LanguageClient_serverCommands =
\ { 'c'         : ['ccls']
\ , 'cpp'       : ['ccls']
\ , 'sh'        : ['bin/bash-language-server', 'start']
\ , 'haskell'   : ['hie-wrapper']
\ , 'javascript': ['typescript-language-server', '--stdio']
\ , 'lua'       : ['lua-lsp']
\ , 'typescript': ['typescript-language-server', '--stdio']
\ }

" Help some language servers find project roots
let g:LanguageClient_rootMarkers = {
\ 'haskell': ['stack.yaml'],
\ }

" Customize symbols
let g:LanguageClient_diagnosticsDisplay =
\ { 1:
\   { 'name'      : 'Error'
\   , 'texthl'    : 'ALEError'
\   , 'signText'  : error_symbol
\   , 'signTexthl': 'ALEErrorSign'
\   }
\ , 2:
\   { 'name'      : 'Warning'
\   , 'texthl'    : 'ALEWarning'
\   , 'signText'  : warnin_symbol
\   , 'signTexthl': 'ALEWarningSign'
\   }
\ , 3:
\   { 'name'      : 'Information'
\   , 'texthl'    : 'ALEInfo'
\   , 'signText'  : info_symbol
\   , 'signTexthl': 'ALEInfoSign'
\   }
\ , 4:
\   { 'name'     : 'Hint'
\   , 'texthl'    : 'ALEInfo'
\   , 'signText'  : '➤'
\   , 'signTexthl': 'ALEInfoSign'
\   }
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

"\ call LanguageClient#isAlive(function('LspMaybeHover'))
augroup lsp_aucommands
  au!
  au CursorHold  * call LanguageClient#isAlive(function('LspMaybeHighlight'))
augroup END

" Language server related shortcuts
call Anoremap('<silent>', '<leader>lh', '<Cmd>call LanguageClient#textDocument_hover()<CR>')
call Anoremap('<silent>', '<leader>ld', '<Cmd>call LanguageClient#textDocument_definition({"gotoCmd": "split"})<CR>')
call Anoremap('<silent>', '<leader>li', '<Cmd>call LanguageClient#textDocument_implementation()<CR>')
call Anoremap('<silent>', '<leader>lr', '<Cmd>call LanguageClient#textDocument_rename()<CR>')
call Anoremap('<silent>', '<leader>lf', '<Cmd>call LanguageClient#textDocument_formatting()<CR>')
call Anoremap('<silent>', '<leader>lt', '<Cmd>call LanguageClient#textDocument_typeDefinition()<CR>')
call Anoremap('<silent>', '<leader>la', '<Cmd>call LanguageClient#workspace_applyEdit()<CR>')
call Anoremap('<silent>', '<leader>ll', '<Cmd>call LanguageClient#textDocument_documentHighlight()<CR>')
call Anoremap('<silent>', '<leader>lc', '<Cmd>Denite codeAction<CR>')
call Anoremap('<silent>', '<leader>lm', '<Cmd>Denite contextMenu<CR>')
call Anoremap('<silent>', '<leader>ls', '<Cmd>Denite documentSymbol<CR>')
call Anoremap('<silent>', '<leader>lS', '<Cmd>Denite workspaceSymbol<CR>')
call Anoremap('<silent>', '<leader>lx', '<Cmd>Denite references<CR>')
call Anoremap('<silent>', '<leader>le', '<Cmd>cnext<CR>')
call Anoremap('<silent>', '<leader>lE', '<Cmd>cprev<CR>')
" }}}

" LINTER/FIXER {{{
" ============
" Asyncronous Linting Engine (ALE)
" Used for linting when no good language server is available
" https://github.com/w0rp/ale

" Disable linters for languges that have defined language servers above
let g:ale_linters =
\ { 'c'         : []
\ , 'sh'        : []
\ , 'haskell'   : []
\ , 'javascript': []
\ , 'lua'       : []
\ , 'typescript': []
\ }

" Configure and enable fixer
let g:ale_fix_on_save = 1
let g:ale_fixers =
\ { '*'         : ['remove_trailing_lines', 'trim_whitespace']
\ , 'javascript': ['prettier-eslint']
\ , 'json'      : ['prettier']
\ , 'puppet'    : ['puppetlint']
\ }

" Customize symbols
let g:ale_sign_error         = error_symbol
let g:ale_sign_warning       = warnin_symbol
let g:ale_sign_info          = info_symbol
let g:ale_sign_style_error   = ''
let g:ale_sign_style_warning = g:ale_sign_style_error
" }}}

" COMPLETION {{{
" ==========
" Deoplete autocompletion engine
" Used to display/manage all completions including those from language servers
" https://github.com/Shougo/deoplete.nvim
augroup deoplete
  au!
  au VimEnter *
\ call deoplete#enable()
\ | call deoplete#custom#var
\   ( 'around'
\   , { 'range_above' : 20
\     , 'range_below' : 20
\     , 'mark_above'  : '[↑]'
\     , 'mark_below'  : '[↓]'
\     , 'mark_changes': '[*]'
\     }
\   )
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

" WRITING AND MARKDOWN {{{
" ====================

" vim-markdown
" Adds a ton of functionality for Markdown
" https://github.com/plasticboy/vim-markdown
let g:vim_markdown_folding_disabled     = 1
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

" MISC PLUGIN {{{
" ===========

" denite.vim
" Powerful list searcher
" https://github.com/Shougo/denite.nvim
augroup deinte
  au!
  au VimEnter *
\ call denite#custom#option
\   ( '_'
\   , { 'auto_resize'            : 'true'
\     , 'highlight_matched_char' : 'SpellRare'
\     , 'highlight_matched_range': 'SpellCap'
\     , 'highlight_mode_insert'  : 'CursorLine'
\     , 'highlight_mode_normal'  : 'CursorLine'
\     , 'ignore'                 : '*/.stack-work'
\     , 'prompt'                 : '->>'
\     , 'reversed'               : 'true'
\     , 'sorters'                : 'sorter/sublime'
\     , 'vertical_preview'       : 'true'
\     }
\   )
\ | call denite#custom#var('grep', 'command'       , ['rg'])
\ | call denite#custom#var('grep', 'default_opts'  , ['-i', '--vimgrep', '--no-heading'])
\ | call denite#custom#var('grep', 'recursive_opts', [])
\ | call denite#custom#var('grep', 'pattern_opt'   , ['--regexp'])
\ | call denite#custom#var('grep', 'separator'     , ['--'])
\ | call denite#custom#var('grep', 'final_opts'    , [])
\ | call denite#custom#alias ('source'          , 'grep/interactive', 'grep')
\ | call denite#custom#source('grep/interactive', 'args'            , ['', '', '!'])
\ | call denite#custom#map('insert', '<ESC>', '<denite:enter_mode:normal>')
\ | call denite#custom#map('normal', '<ESC>', '<denite:quit>')
\ | call denite#custom#map('normal', 's'    , '<denite:do_action:split>')
\ | call denite#custom#map('normal', 'v'    , '<denite:do_action:vsplit>')
augroup END

call Anoremap('<silent>', '<leader><space>', '<Cmd>Denite source<CR>')
call Anoremap('<silent>', '<leader>sb'     , '<Cmd>Denite buffer<CR>')
call Anoremap('<silent>', '<leader>scc'    , '<Cmd>Denite command<CR>')
call Anoremap('<silent>', '<leader>sch'    , '<Cmd>Denite command_history<CR>')
call Anoremap('<silent>', '<leader>sh'     , '<Cmd>Denite help<CR>')
call Anoremap('<silent>', '<leader>sf'     , '<Cmd>Denite file<CR>')
call Anoremap('<silent>', '<leader>sr'     , '<Cmd>Denite file/rec<CR>')
call Anoremap('<silent>', '<leader>sp'     , '<Cmd>DeniteProjectDir file/rec<CR>')
call Anoremap('<silent>', '<leader>sg'     , '<Cmd>DeniteProjectDir grep<CR>')
call Anoremap('<silent>', '<leader>si'     , '<Cmd>DeniteProjectDir grep/interactive<CR>')
call Anoremap('<silent>', '<leader>sw'     , '<Cmd>execute "Denite -input=".expand("<cword>")." grep"<CR>')
call Anoremap('<silent>', '<leader>sll'    , '<Cmd>Denite line<CR>')
call Anoremap('<silent>', '<leader>slw'    , '<Cmd>DeniteCursorWord line<CR>')
call Anoremap('<silent>', '<leader>ss'     , '<Cmd>Denite spell<CR>')
call Anoremap('<silent>', '<leader>sr'     , '<Cmd>Denite -resume<CR>')

" GitGutter
" https://github.com/airblade/vim-gitgutter
let g:gitgutter_override_sign_column_highlight = 0     " make sign column look consistent
let g:gitgutter_sign_added    = '┃'                    " replace default symbols with something nicer
let g:gitgutter_sign_modified = g:gitgutter_sign_added
let g:gitgutter_sign_removed  = g:gitgutter_sign_added

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
