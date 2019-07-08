" vim: foldmethod=marker
scriptencoding=utf-8

" Comments and Context {{{
" ====================
"
" Keyboard shortcut philosophy:
" * Don't change default shortcuts unless there a consistent model for the change.
" * Leader shortcuts are for commands that don't fit nicely into Vim's shortcut grammar.
"   * Avoid single key leader shortcuts. Have the first key be some mnemonic for what the command does.
"   * <leader>l for language server related commands.
"   * <leader>w for window related commands.
"   * <leader>s for search (Denite) related commands.
"   * <leader>t for tab related commands.
"   * <leader>q for quit/close related commands.
" }}}

" Basic Vim Config {{{
" ================

let mapleader = '`'
let timeouttlen = 2000 " extend time-out on leader key
set scrolloff=5        " start scrolling when cursor is within 5 lines of the edge
set linebreak          " soft wraps on words not individual chars
set mouse=a            " enable mouse support in all modes
set autochdir

" Search and replace
set ignorecase         " make searches with lower case characters case insensative
set smartcase          " search is case sensitive only if it contains uppercase chars
set inccommand=nosplit " show preview in buffer while doing find and replace

" Tab key behavior
set expandtab 	 " Convert tabs to spaces
set tabstop=2    " Width of tab character
set shiftwidth=2 " Width of auto-indents

" Check if file has changed on disk, if it has and buffer has no changes, reload it
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

" UI General {{{
" ==========

" Misc basic vim ui config
set colorcolumn=100 " show column boarder
set cursorline      " highlight current line
set noshowmode      " don't show --INSERT-- etc.
set relativenumber  " relative line numbers
set signcolumn=yes  " always have signcolumn open to avoid thing shifting around all the time
set termguicolors   " truecolor support

" Setup color scheme
" https://github.com/icymind/NeoSolarized
let g:neosolarized_italic           = 1 " enable italics (must come before colorcheme command)
let g:neosolarized_termBoldAsBright = 0 " don't change color of text when bolded in terminal
colorscheme NeoSolarized                " version of solarized that works better with truecolors
hi! link SignColumn Normal

" Variables for symbol used in config
let error_symbol      = ''
let warning_symbol    = ''
let info_symbol       = ''

let ibar_symbol       = ''
let git_branch_symbol = ''
let list_symbol       = ''
let lock_symbol       = ''
let pencil_symbol     = ''
let question_symbol   = ''
let spinner_symbol    = ''
let term_symbol       = ''
let vim_symbol        = ''
let wand_symbol       = ''
" }}}

" UI Status Line {{{
" ==============
" https://github.com/vim-airline/vim-airline

" General configuration
let g:airline#parts#ffenc#skip_expected_string = 'utf-8[unix]' " only show unusual file encoding
let g:airline#extensions#hunks#non_zero_only   = 1             " only git stats when there are changes
let g:airline_skip_empty_sections              = 1             " don't show sections if they're empty
let g:airline_extensions =
\ [ 'ale'
\ , 'branch'
\ , 'coc'
\ , 'denite'
\ , 'fugitiveline'
\ , 'keymap'
\ , 'netrw'
\ , 'quickfix'
\ , 'tabline'
\ , 'whitespace'
\ , 'wordcount'
\ ]

" Tabline configuration
"let g:airline#extensions#tabline#enabled           = 1 " needed since it isn't on by default
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

let g:airline_symbols.branch    = git_branch_symbol
let g:airline_symbols.readonly  = lock_symbol
let g:airline_symbols.notexists = question_symbol
let g:airline_symbols.dirty     = pencil_symbol
let g:airline_mode_map =
\ { '__': '-'
\ , 'c' : term_symbol
\ , 'i' : pencil_symbol
\ , 'ic': pencil_symbol.' '.list_symbol
\ , 'ix': pencil_symbol.' '.list_symbol
\ , 'n' : vim_symbol
\ , 'ni': 'N'
\ , 'no': spinner_symbol
\ , 'R' : 'R'
\ , 'Rv': 'R VIRTUAL'
\ , 's' : 'S'
\ , 'S' : 'S LINE'
\ , '': 'S BLOCK'
\ , 't' : term_symbol
\ , 'v' : ibar_symbol
\ , 'V' : ibar_symbol.' LINE'
\ , '': ibar_symbol.' BLOCK'
\ }
let airline#extensions#ale#error_symbol         = error_symbol.':'
let airline#extensions#ale#warning_symbol       = warning_symbol.':'
let airline#extensions#coc#error_symbol         = error_symbol.':'
let airline#extensions#coc#warning_symbol       = warning_symbol.':'
let g:airline#extensions#quickfix#quickfix_text = wand_symbol
let g:airline#extensions#quickfix#location_text = list_symbol

" Patch in missing colors for terminal status line
let g:airline_theme_patch_func = 'AirlineThemePatch'
function! AirlineThemePatch(palette)
  if g:airline_theme ==# 'solarized'
    for key in ['normal', 'insert', 'replace', 'visual', 'inactive']
      let a:palette[key].airline_term = a:palette[key].airline_x
    endfor
    let a:palette.inactive.airline_choosewin = [g:terminal_color_7, g:terminal_color_2, 2, 7, 'bold']
  endif
endfunction
" }}}

" UI Window Chooser {{{
" =================

" vim-choosewin
" mimic tmux's display-pane feature
" https://github.com/t9md/vim-choosewin
" color setting in BASIC VIM CONFIG section
call Anoremap('<silent>', '<leader><leader>', '<Cmd>call ActiveChooseWin()<CR>')
let g:choosewin_active = 0
let g:choosewin_label = 'TNERIAODH' " alternating on homerow for colemak (choosewin uses 'S')
let g:choosewin_tabline_replace = 0    " don't use ChooseWin tabline since Airline provides numbers
let g:choosewin_statusline_replace = 0 " don't use ChooseWin statusline, since we make our own below

" Setup autocommands to customize status line for ChooseWin
augroup choosevim_airline
  au!
  au User AirlineAfterInit call airline#add_statusline_func('ChooseWinAirline')
  au User AirlineAfterInit call airline#add_inactive_statusline_func('ChooseWinAirline')
augroup END

" Create custom status line when ChooseWin is trigger
function! ChooseWinAirline(builder, context)
  if g:choosewin_active == 1
    " Define label
    let label_pad = "      "
    let label = label_pad . g:choosewin_label[a:context.winnr-1] . label_pad

    " Figure out how long sides need to be
    let total_side_width = (winwidth(a:context.winnr)) - 2 - strlen(label) " -2 is for separators
    let side_width = total_side_width / 2

    " Create side padding
    let right_pad = ""
    for i in range(1, side_width) | let right_pad = right_pad . " " | endfor
    let left_pad = (total_side_width % 2 == 1) ? right_pad . " " : right_pad

    if a:context.active == 0
      " Define status line for inactive windows
      call a:builder.add_section('airline_a', left_pad)
      call a:builder.add_section('airline_choosewin', label)
      call a:builder.split()
      call a:builder.add_section('airline_z', right_pad)
    else
      " Define status line of active windows
      call a:builder.add_section('airline_b', left_pad)
      call a:builder.add_section('airline_x', label)
      call a:builder.split()
      call a:builder.add_section('airline_y', right_pad)
    endif
    return 1
  endif

  return 0
endfunction

" Custom function to launch ChooseWin
function! ActiveChooseWin() abort
  let g:choosewin_active = 1 " Airline doesn't see when ChooseWin toggles this
  AirlineRefresh
  ChooseWin
endfunction
" }}}

" UI Welcome Screen {{{
" =================

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
\     , ' let nixRebuildOutput=system("nixuser-rebuild")
\       | let newVimConfig=system("nix-store --query --references (which nvim) | grep vimrc")
\       | execute "source" newVimConfig
\       | redraw
\       | echo nixRebuildOutput
\       '
\     ]
\   }
\ ]
" }}}

" Window/Tab Creation/Navigation {{{
" =============================

" Make escape more sensible in terminal mode
tnoremap <ESC> <C-\><C-n>    " enter normal mode
tnoremap <leader><ESC> <ESC> " send escape to terminal

" Start new terminals in insert mode
augroup nvimTerm
  au TermOpen * if &buftype == 'terminal' | :startinsert | endif
augroup END

" Set where splits open
set splitbelow " open horizontal splits below instead of above which is the default
set splitright " open vertical splits to the right instead of the left with is the default

" Tab creation/destruction
call Anoremap('<silent>', '<leader>tt', '<Cmd>tabnew +Startify<CR>') " new tab w/ Startify
call Anoremap('<silent>', '<leader>to', '<Cmd>tabonly<CR>')         " close all other tabs
call Anoremap('<silent>', '<leader>qt', '<Cmd>tabclose<CR>')         " close tab

" Tab navigation
call Anoremap('<silent>', '<leader>tn', '<Cmd>tabnext<CR>')     " next tab
call Anoremap('<silent>', '<leader>tN', '<Cmd>tabprevious<CR>') " previous tab

" Split creation/destruction
call Anoremap('<silent>', '<leader>-' , '<Cmd>new +term<CR>')           " new horizontal window w/ terminal
call Anoremap('<silent>', '<leader>_' , '<Cmd>botright new +term<CR>')  " new full width horizontal window w/ terminal
call Anoremap('<silent>', '<leader>\' , '<Cmd>vnew +term<CR>')          " new vertical window w/ terminal
call Anoremap('<silent>', '<leader>\|', '<Cmd>botright vnew +term<CR>') " new full height vertical window w/ terminal
call Anoremap('<silent>', '<leader>ws', '<Cmd>split<CR>')               " new horizontal split
call Anoremap('<silent>', '<leader>wv', '<Cmd>vsplit<CR>')              " new vertical split
call Anoremap('<silent>', '<leader>qw', '<Cmd>q<CR>')                   " close window
call Anoremap('<silent>', '<leader>wo', '<Cmd>only<CR>')                " close all other windows

" Split movement
call Anoremap('<silent>', '<leader>wmk', '<C-w>K') " move window to very top and make full width
call Anoremap('<silent>', '<leader>wmj', '<C-w>J') " move window to very bottom and make full width
call Anoremap('<silent>', '<leader>wmh', '<C-w>H') " move window to fast left and make full height
call Anoremap('<silent>', '<leader>wml', '<C-w>L') " move window to fast right and make full height
call Anoremap('<silent>', '<leader>wmt', '<C-w>T') " move window to new tab


" Split navigation
call Anoremap('<silent>', '<leader>wh', '<Cmd>wincmd h<CR>') " move left
call Anoremap('<silent>', '<leader>wl', '<Cmd>wincmd l<CR>') " move right
call Anoremap('<silent>', '<leader>wk', '<Cmd>wincmd k<CR>') " move up
call Anoremap('<silent>', '<leader>wj', '<Cmd>wincmd j<CR>') " move down

" Close various special windows
call Anoremap('<silent>', '<leader>qh', '<Cmd>helpclose<CR>') " close help
call Anoremap('<silent>', '<leader>qp', '<Cmd>pclose<CR>')    " close preview
call Anoremap('<silent>', '<leader>qc', '<Cmd>cclose<CR>')    " close quickfix list
"" }}}

" List Searcher {{{
" =============

" denite.vim
" Powerful list searcher
" https://github.com/Shougo/denite.nvim
augroup denite_settings
  au!
  au FileType denite        call s:denite_maps()
  " au FileType denite-filter call deoplete#custom#buffer_option('auto_complete', v:false)
  au VimEnter *             call s:denite_settings()
augroup END

" Denite buffer command mapping
function! s:denite_maps() abort
  " general commands
  nnoremap <silent><buffer><expr> <TAB>   denite#do_map('choose_action')
  nnoremap <silent><buffer><expr> <CR>    denite#do_map('do_action') " do default action
  nnoremap <silent><buffer><expr> <ESC>   denite#do_map('quit')
  nnoremap <silent><buffer><expr> u       denite#do_map('move_up_path')
  nnoremap <silent><buffer><expr> i       denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space> denite#do_map('toggle_select')
  nnoremap <silent><buffer><expr> *       denite#do_map('toggle_select_all')
  " global actions
  nnoremap <silent><buffer><expr> A       denite#do_map('do_action', 'append')  " insert the candidate after the cursor
  nnoremap <silent><buffer><expr> E       denite#do_map('do_action', 'echo')    " print the candidates to denite messages
  nnoremap <silent><buffer><expr> R       denite#do_map('do_action', 'replace') " replace word under cursor with candidate
  nnoremap <silent><buffer><expr> Y       denite#do_map('do_action', 'yank')    " yank the candidate
  " buffer actions (default 'open')
  nnoremap <silent><buffer><expr> d       denite#do_map('do_action', 'delete') " delete the buffer
  " command actions (default 'execute')
  nnoremap <silent><buffer><expr> e       denite#do_map('do_action', 'edit') " edit command than execute
  " directory actions (default 'narrow')
  nnoremap <silent><buffer><expr> c       denite#do_map('do_action', 'cd') " change vim current dir
  " file actions (default 'open', i.e., ':edit' the file)
  nnoremap <silent><buffer><expr> D       denite#do_map('do_action', 'drop')     " ':drop' file
  nnoremap <silent><buffer><expr> p       denite#do_map('do_action', 'preview')  " preview file
  nnoremap <silent><buffer><expr> q       denite#do_map('do_action', 'quickfix') " set the quickfix list and open it
  nnoremap <silent><buffer><expr> l       denite#do_map('do_action', 'location') " set the location list and open it
  " openable actions (for buffers and files)
  nnoremap <silent><buffer><expr> O       denite#do_map('do_action', 'open')         " ':edit' the candidate
  nnoremap <silent><buffer><expr> T       denite#do_map('do_action', 'tabopen')      " open the candidate in a tab
  nnoremap <silent><buffer><expr> S       denite#do_map('do_action', 'split')        " open the candidate in a horizontal split
  nnoremap <silent><buffer><expr> V       denite#do_map('do_action', 'vsplit')       " open the candidate in a vertical split
  nnoremap <silent><buffer><expr> o       denite#do_map('do_action', 'switch')       " switch to window if open, else 'open'
  nnoremap <silent><buffer><expr> t       denite#do_map('do_action', 'tabswitch')    " switch to window if open, else 'tabopen'
  nnoremap <silent><buffer><expr> s       denite#do_map('do_action', 'splitswitch')  " switch to window if open, else 'split'
  nnoremap <silent><buffer><expr> v       denite#do_map('do_action', 'vsplitswitch') " switch to window if open, else 'vsplit'
endfunction

" Denite options/configuration
function! s:denite_settings() abort
  " set options for all Denite buffers
  call denite#custom#option('_',
  \ { 'auto_resize'                : v:true
  \ , 'highlight_matched_char'     : 'SpellRare'
  \ , 'highlight_matched_range'    : 'SpellCap'
  \ , 'prompt'                     : '->'
  \ , 'reversed'                   : v:true
  \ , 'smartcase'                  : v:true
  \ , 'sorters'                    : 'sorter/sublime'
  \ , 'statusline'                 : v:false
  \ , 'vertical_preview'           : v:true
  \ })
  " set options for specific Denite buffers
  call denite#custom#option('buffer'          , 'default_action', 'switch')
  call denite#custom#option('file'            , 'default_action', 'switch')
  call denite#custom#option('file/rec'        , 'default_action', 'switch')
  call denite#custom#option('grep'            , 'default_action', 'switch')
  call denite#custom#option('grep/interactive', 'default_action', 'switch')
  " use Ripgrep for grep source
  call denite#custom#var('grep', 'command'       , ['rg'])
  call denite#custom#var('grep', 'default_opts'  , ['-i', '--vimgrep', '--no-heading'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt'   , ['--regexp'])
  call denite#custom#var('grep', 'separator'     , ['--'])
  call denite#custom#var('grep', 'final_opts'    , [])
  " redefine diretory search to ignore hidden folders
  call denite#custom#var
  \ ('directory_rec'
  \ , 'command'
  \ , [ 'find'
  \   , ':directory'
  \   , '-type', 'd'
  \   , '-not', '-path', '*\/.*'
  \   , '-print'
  \   ]
  \ )
  " create interactive grep source
  " TODO: fix Denite errors
  call denite#custom#alias ('source'          , 'grep/interactive', 'grep')
  call denite#custom#source('grep/interactive', 'args'            , ['', '', '!'])
  " change default matchers for some sources
  call denite#custom#source('file'         , 'matchers', ['matcher/fuzzy', 'matcher/hide_hidden_files'])
  call denite#custom#source('file/rec'     , 'matchers', ['matcher/fuzzy', 'matcher/hide_hidden_files'])
endfunction

" Denite source mappings
" buffers
call Anoremap('<silent>', '<leader>sb' , '<Cmd>Denite buffer<CR>')
" ':changes' results
call Anoremap('<silent>', '<leader>sc' , '<Cmd>Denite change<CR>')
" commands
call Anoremap('<silent>', '<leader>sx' , '<Cmd>Denite command<CR>')
" commands history
call Anoremap('<silent>', '<leader>sh' , '<Cmd>Denite command_history<CR>')
" directories
call Anoremap('<silent>', '<leader>sd' , '<Cmd>DeniteProjectDir directory_rec<CR>') " in project folder
call Anoremap('<silent>', '<leader>s~' , '<Cmd>Denite -path=~ directory_rec<CR>')   " in home folder
call Anoremap('<silent>', '<leader>s/' , '<Cmd>Denite -path=/ directory_rec<CR>')   " in root folder
" files
call Anoremap('<silent>', '<leader>sf' , '<Cmd>Denite file<CR>')               " in current folder
call Anoremap('<silent>', '<leader>sr' , '<Cmd>Denite file/rec<CR>')           " in current folder recursively
call Anoremap('<silent>', '<leader>sp' , '<Cmd>DeniteProjectDir file/rec<CR>') " in project folder recursively
" filetypes
call Anoremap('<silent>', '<leader>st' , '<Cmd>Denite filetype<CR>')
" grep results
call Anoremap('<silent>', '<leader>sg' , '<Cmd>DeniteProjectDir grep<CR>')             " in project folder
call Anoremap('<silent>', '<leader>si' , '<Cmd>DeniteProjectDir grep/interactive<CR>') " in project folder interactively
call Anoremap('<silent>', '<leader>sw' , '<Cmd>execute "DeniteProjectDir -input=".expand("<cword>")." grep"<CR>') " in project folder w/ cursor word
" help tags
call Anoremap('<silent>', '<leader>s?' , '<Cmd>Denite help<CR>')
" ':jump' results
call Anoremap('<silent>', '<leader>sj' , '<Cmd>Denite jump<CR>')
" lines of buffer
call Anoremap('<silent>', '<leader>sll', '<Cmd>Denite line<CR>')
call Anoremap('<silent>', '<leader>slw', '<Cmd>DeniteCursorWord line<CR>') " starting w/ cursor word
" outline (ctags)
call Anoremap('<silent>', '<leader>so' , '<Cmd>Denite outline<CR>')
" registers
call Anoremap('<silent>', '<leader>s"' , '<Cmd>Denite register<CR>')
" spell suggestions
call Anoremap('<silent>', '<leader>ss' , '<Cmd>Denite spell<CR>')
" resume previous search
call Anoremap('<silent>', '<leader>sr' , '<Cmd>Denite -resume<CR>')
" }}}

" Coc.vim {{{
" =======

set hidden         " if not set, TextEdit might fail
set nobackup       " some lang servers have issues with backups, should be default, set just in case
set nowritebackup
set updatetime=300 " smaller update time for CursorHold and CursorHoldI
set shortmess+=c   " don't show ins-completion-menu messages.

" General configuration
let g:coc_global_extensions =
\ [ 'coc-eslint'
\ , 'coc-import-cost'
\ , 'coc-json'
\ , 'coc-git'
\ , 'coc-lists'
\ , 'coc-pairs'
\ , 'coc-tsserver'
\ , 'coc-vimlsp'
\ , 'coc-yaml'
\ ]

let g:coc_user_config =
\ { 'coc.preferences':
\     { 'formatOnSaveFiletypes': []
\     , 'jumpCommand'          : 'split'
\     }
\ , 'codeLens':
\     { 'enable': v:true
\     }
\ , 'diagnostic':
\     { 'virtualText'        : v:true
\     , 'refreshOnInsertMode': v:false
\     , 'errorSign'          : error_symbol
\     , 'warningSign'        : warning_symbol
\     , 'infoSign'           : info_symbol
\     , 'hintSign'           : info_symbol
\     }
\ , 'list':
\     { 'indicator'         : '->>'
\     , 'selectedSignText'  : ''
\     , 'extendedSearchMode': v:true
\     , 'normalMappings'    : {}
\     , 'insertMappings'    :
\         { '<CR>' : '<C-o>'
\         }
\     }
\ , 'suggest':
\     { 'enablePreview'           : v:true
\     , 'detailField'             : 'menu'
\     , 'snippetIndicator'        : ''
\     , 'completionItemKindLabels':
\         { 'keyword'      : ''
\         , 'variable'     : ''
\         , 'value'        : ''
\         , 'operator'     : 'Ψ'
\         , 'function'     : 'ƒ'
\         , 'reference'    : '渚'
\         , 'constant'     : ''
\         , 'method'       : ''
\         , 'struct'       : 'פּ'
\		      , 'class'        : ''
\         , 'interface'    : ''
\         , 'text'         : ''
\         , 'enum'         : ''
\         , 'enumMember'   : ''
\         , 'module'       : ''
\         , 'color'        : ''
\         , 'property'     : ''
\         , 'field'        : '料'
\         , 'unit'         : ''
\         , 'event'        : '鬒'
\         , 'file'         : ''
\         , 'folder'       : ''
\         , 'snippet'      : ''
\         , 'typeParameter': ''
\         , 'default'      : ''
\	        }
\     }
\ , 'languageserver':
\     { 'haskell':
\         { 'command'     : 'hie-8.6.5'
\         , 'filetypes'   : ['hs', 'lhs', 'haskell']
\         , 'rootPatterns': ['stack.yaml']
\         , 'initializationOptions': {}
\         }
\     , 'ccls':
\         { 'command'     : 'ccls'
\         , 'filetypes'   : ['c', 'cpp', 'objc', 'objcpp']
\         , 'rootPatterns': ['.ccls', 'compile_commands.json', '.git/']
\         , 'initializationOptions': {}
\         }
\     , 'bash':
\         { 'command'         : 'bash-language-server'
\         , 'args'            : ['start']
\         , 'filetypes'       : ['sh']
\         , 'ignoredRootPaths': ['~']
\         }
\     }
\ , 'eslint':
\     { 'filetypes': ['javascript', 'typescript']
\     }
\ , 'git':
\     { 'changedSign.text'         : '┃'
\     , 'addedSign.text'           : '┃'
\     , 'removedSign.text'         : '_'
\     , 'topRemovedSign.text'      : '‾'
\     , 'changeRemovedSign.text'   : '≃'
\     , 'addedSign.hlGroup'        : 'GitGutterAdd'
\     , 'changedSign.hlGroup'      : 'GitGutterChange'
\     , 'removedSign.hlGroup'      : 'GitGutterDelete'
\     , 'topRemovedSign.hlGroup'   : 'GitGutterDelete'
\     , 'changeRemovedSign.hlGroup': 'GitGutterChangeDelete'
\     }
\ , 'importCost.debug': v:true
\ }

let g:coc_status_error_sign   = error_symbol
let g:coc_status_warning_sign = warning_symbol
let g:markdown_fenced_languages = ['vim', 'help']

" Keybindings
nmap <silent> <leader>le <Plug>(coc-diagnostic-info)
nmap <silent>         [c <Plug>(coc-diagnostic-prev)
nmap <silent>         ]c <Plug>(coc-diagnostic-next)
nmap <silent>         gd <Plug>(coc-definition)
"<Plug>(coc-declaration)
nmap <silent>         gi <Plug>(coc-implementation)
nmap <silent>         gy <Plug>(coc-type-definition)
nmap <silent>         gr <Plug>(coc-references)
vmap <silent> <leader>lf <Plug>(coc-format-selected)
nmap <silent> <leader>lf <Plug>(coc-format-selected)
nmap <silent> <leader>lF <Plug>(coc-format)
nmap <silent> <leader>lr <Plug>(coc-rename)
nmap <silent> <leader>la <Plug>(coc-codeaction)
nmap <silent> <leader>lc <Plug>(coc-codelens-action)
nmap <silent> <leader>lq <Plug>(coc-fix-current)
nmap <silent>         K  :call CocAction('doHover')<CR>
nmap <silent> <leader>ls :Denite coc-symbols<CR>
nmap <silent> <leader>lS :Denite coc-workspace<CR>
nmap <silent> <leader>lE :Denite coc-diagnostic<CR>
" use tab to navigate completion menu and jump in snippets
inoremap <expr> <Tab>
\ pumvisible()
\ ? '<C-n>'
\ : coc#jumpable()
\   ? '<C-r>=coc#rpc#request("doKeymap", ["snippets-expand-jump",""])<CR>'
\   : '<Tab>'
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" navigate chunks of current buffer
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
" show chunk diff at current position
nmap gs <Plug>(coc-git-chunkinfo)


augroup coc_autocomands
  au!
  " Setup formatexpr specified filetypes (default binding is gq)
  au FileType typescript,json,haskell setl formatexpr=CocAction('formatSelected')
  " Highlight symbol under cursor on CursorHold
  au CursorHold * silent call CocActionAsync('highlight')
  " Update signature help on jump placeholder
  " TODO: understand what this does
  au User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  " Close preview window when completion is done
  au CompleteDone * if pumvisible() == 0 | pclose | endif
augroup end

" Make highlights fit in with colorscheme
hi link CocErrorSign NeomakeErrorSign
hi link CocWarningSign NeomakeWarningSign
hi link CocInfoSign NeomakeInfoSign
hi link CocHintSign NeomakeMessagesSign
hi link CocErrorHighlight SpellBad
hi link CocWarningHighlight SpellLocal
hi link CocInfoHighlight CocUnderline
hi link CocHintHighlight SpellRare
hi link CocHighlightText SpellCap
hi link CocCodeLens Comment

" }}}

" Linter/Fixer {{{
" ============
" Asyncronous Linting Engine (ALE)
" Used for linting when no good language server is available
" https://github.com/w0rp/ale

" Disable linters for languges that have defined language servers above
let g:ale_linters =
\ { 'c'         : []
\ , 'haskell'   : []
\ , 'javascript': []
\ , 'lua'       : []
\ , 'sh'        : []
\ , 'typescript': []
\ , 'vim'       : []
\ }

" Configure and enable fixer
let g:ale_fix_on_save = 1
let g:ale_fixers = { '*' : ['remove_trailing_lines', 'trim_whitespace'] }

" Customize symbols
let g:ale_sign_error         = error_symbol
let g:ale_sign_warning       = warning_symbol
let g:ale_sign_info          = info_symbol
let g:ale_sign_style_error   = pencil_symbol
let g:ale_sign_style_warning = g:ale_sign_style_error
" }}}

" Writing {{{
" =======

" vim-pencil
" Adds a bunch of really nice features for writing
" https://github.com/reedes/vim-pencil
let g:pencil#wrapModeDefault = 'soft'   " default is 'hard'
let g:airline_section_x = '%{PencilMode()}'
augroup pencil
  au!
  au FileType markdown,mkd,text call pencil#init() | set spell
augroup END

" Goyo
" Distraction free writing mode for vim
" https://github.com/junegunn/goyo.vim
" }}}

" Filetype Specific {{{
" =================

" Most filetypes
" vim-polyglot
" A solid language pack for Vim
" https://github.com/sheerun/vim-polyglot

" Haskell
" haskell-vim (comes in vim-polyglot)
" https://github.com/neovimhaskell/haskell-vim.git
" indenting options
let g:haskell_indent_if               = 3
let g:haskell_indent_case             = 2
let g:haskell_indent_let              = 4
let g:haskell_indent_where            = 6
let g:haskell_indent_before_where     = 2
let g:haskell_indent_after_bare_where = 2
let g:haskell_indent_do               = 3
let g:haskell_indent_in               = 1
let g:haskell_indent_guard            = 2
" turn on extra highlighting
let g:haskell_backpack                = 1 " to enable highlighting of backpack keywords
let g:haskell_enable_arrowsyntax      = 1 " to enable highlighting of `proc`
let g:haskell_enable_quantification   = 1 " to enable highlighting of `forall`
let g:haskell_enable_recursivedo      = 1 " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_static_pointers  = 1 " to enable highlighting of `static`
let g:haskell_enable_typeroles        = 1 " to enable highlighting of type roles

" Javascript
" vim-javascript (comes in vim-polyglot)
" https://github.com/pangloss/vim-javascript
let g:javascript_plugin_jsdoc = 1

" Markdown
" vim-markdown (comes in vim-polyglot)
" https://github.com/plasticboy/vim-markdown
let g:vim_markdown_folding_disabled     = 1
let g:vim_markdown_new_list_item_indent = 2
set conceallevel=2

" Typescript
" yats.vim
" https://github.com/herringtondarkholme/yats.vim
" let g:polyglot_disabled = ['typescript']
" }}}

" Misc {{{
" ====

" vim-fugitive
" A Git wrapper so awesome, it should be illegal
" https://github.com/tpope/vim-fugitive

" tabular
" Helps vim-markdown with table formatting amoung many other things
" https://github.com/godlygeek/tabular

" vim-commentary
" Comment stuff out (easily)
" https://github.com/tpope/vim-commentary

" vim-surround
" Quoting/parenthesizing made simple
" https://github.com/tpope/vim-surround
" }}}
