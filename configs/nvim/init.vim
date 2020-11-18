" vim: foldmethod=marker
scriptencoding=utf-8

" Comments and Context {{{
" ====================
"
" Keyboard shortcut philosophy:
" * Don't change default shortcuts unless there a consistent model for the change.
" * Use <space> prefixed shortcuts are for commands that don't fit nicely into Vim's shortcut grammar.
"   * Avoid single key shortcuts. Have the first key be some mnemonic for what the command does.
"   * <space>l for language server related commands.
"   * <space>w for split/window related commands.
"   * <space>m for split/window movement/manipulation related commands.
"   * <space>s for search (CocList) related commands.
"   * <space>t for tab related commands.
"   * <space>q for quit/close related commands.
"   * <space>g for git related commands.
"
" TODO:
" * Get underline working when terminal can't display squiggly version
" * ':' keybiding in terminal insert mode
" * Factor some symbols and colors out to nix config
" * Fix colors for Choosewin landing highlight and inactive window selection labels
" }}}

" Basic Vim Config {{{
" ================

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

" Set where splits open
set splitbelow " open horizontal splits below instead of above which is the default
set splitright " open vertical splits to the right instead of the left with is the default
" }}}

" UI General {{{
" ==========

" Misc basic vim ui config
set colorcolumn=100 " show column boarder
set cursorline      " highlight current line
set noshowmode      " don't show --INSERT-- etc.
set number
set relativenumber  " relative line numbers
set signcolumn=yes  " always have signcolumn open to avoid thing shifting around all the time
set t_Co=16         " use the 16 ANSI terminal colors

" Setup color scheme
" https://github.com/icymind/NeoSolarized
let g:neosolarized_italic           = 1 " enable italics (must come before colorscheme command)
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
let g:airline#extensions#hunks#coc_git         = 1             " only git stats when there are changes
let g:airline_skip_empty_sections              = 1             " don't show sections if they're empty
let g:airline_extensions =
\ [ 'ale'
\ , 'branch'
\ , 'coc'
\ , 'fugitiveline'
\ , 'netrw'
\ , 'quickfix'
\ , 'tabline'
\ , 'whitespace'
\ , 'wordcount'
\ , 'zoomwintab'
\ ]

" Tabline configuration
let g:airline#extensions#tabline#show_tabs         = 1 " always show tabs in tabline
let g:airline#extensions#tabline#show_buffers      = 0 " don't show buffers in tabline
let g:airline#extensions#tabline#show_splits       = 0 " don't number of splits
let g:airline#extensions#tabline#tab_nr_type       = 2 " tabs show [tab num].[num of splits in tab]
let g:airline#extensions#tabline#show_tab_type     = 0 " don't show tab or buffer labels in bar
let g:airline#extensions#tabline#show_close_button = 0 " don't display close button in top right

" Cutomtomize symbols
let g:airline_powerline_fonts = 1
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_symbols.branch    = git_branch_symbol
let g:airline_symbols.readonly  = lock_symbol
let g:airline_symbols.notexists = question_symbol
let g:airline_symbols.dirty     = pencil_symbol
let g:airline_mode_map =
\ { '__'    : '-'
\ , 'c'     : term_symbol
\ , 'i'     : pencil_symbol
\ , 'ic'    : pencil_symbol.' '.list_symbol
\ , 'ix'    : pencil_symbol.' '.list_symbol
\ , 'multi' : 'M'
\ , 'n'     : vim_symbol
\ , 'ni'    : 'N'
\ , 'no'    : spinner_symbol
\ , 'R'     : 'R'
\ , 'Rv'    : 'R VIRTUAL'
\ , 's'     : 'S'
\ , 'S'     : 'S LINE'
\ , ''    : 'S BLOCK'
\ , 't'     : term_symbol
\ , 'v'     : ibar_symbol
\ , 'V'     : ibar_symbol.' LINE'
\ , ''    : ibar_symbol.' BLOCK'
\ }
let airline#extensions#ale#error_symbol         = error_symbol.':'
let airline#extensions#ale#warning_symbol       = warning_symbol.':'
let airline#extensions#coc#error_symbol         = error_symbol.':'
let airline#extensions#coc#warning_symbol       = warning_symbol.':'
let g:airline#extensions#quickfix#quickfix_text = wand_symbol
let g:airline#extensions#quickfix#location_text = list_symbol

" Patch in missing colors for terminal status line
let g:airline_solarized_normal_green = 1
let g:airline_theme_patch_func = 'AirlineThemePatch'
function! AirlineThemePatch(palette)
  if g:airline_theme ==# 'solarized'
    for key in ['normal', 'insert', 'replace', 'visual', 'inactive']
      let a:palette[key].airline_term = a:palette[key].airline_x
    endfor
    " TODO: Fix this, it doesn't do what I want
    let a:palette.inactive.airline_choosewin = a:palette.normal.airline_a
  endif
endfunction

" Add Coc status to Airline (for some reason they don't if you have autochdir on)
augroup airline-group
  au!
  au User AirlineAfterInit let g:airline_section_c =
    \ airline#section#create(['%<', 'file', ' ', 'readonly', 'coc_status'])
augroup END

" Add overide for Coc List buffers
let g:airline_filetype_overrides = {
\ 'list': [ 'Coc List', '%f' ],
\ }
" }}}

" UI Window Chooser {{{
" =================

" vim-choosewin
" mimic tmux's display-pane feature
" https://github.com/t9md/vim-choosewin
" color setting in BASIC VIM CONFIG section
let g:choosewin_active = 0
let g:choosewin_label = 'TNERIAODH'    " alternating on homerow for colemak (choosewin uses 'S')
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
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''

    " Define label
    let label_pad = "       "
    let label = label_pad . g:choosewin_label[a:context.winnr-1] . label_pad

    " Figure out how long sides need to be
    let total_side_width = (winwidth(a:context.winnr)) - strlen(label) " add -2 with separators
    let side_width = total_side_width / 2

    " Create side padding
    let right_pad = ""
    for i in range(1, side_width) | let right_pad = right_pad . " " | endfor
    let left_pad = (total_side_width % 2 == 1) ? right_pad . " " : right_pad

    if a:context.active == 0
      " Define status line for inactive windows
      call a:builder.add_section('airline_c', left_pad)
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

  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  return 0
endfunction

" Custom function to launch ChooseWin
function! ActiveChooseWin() abort
  let g:choosewin_active = 1 " Airline doesn't see when ChooseWin toggles this
  AirlineRefresh
  ChooseWin
  AirlineRefresh
endfunction
" }}}

" UI Welcome Screen {{{
" =================

" Startify
" Start screen configuration
" https://github.com/mhinz/vim-startify
let g:startify_files_number        = 10 " max number of files/dirs in lists
let g:startify_relative_path       = 1  " use relative path if file is below current directory
let g:startify_update_oldfiles     = 1  " update old file list whenever Startify launches
let g:startify_fortune_use_unicode = 1  " use unicode rather than ASCII in fortune

" Define Startify lists
let g:startify_lists =
\ [ {'type': 'files'    , 'header': ['      Recent']}
\ , {'type': 'dir'      , 'header': ['      Recent in '. getcwd()]}
\ , {'type': 'bookmarks', 'header': ['      Bookmarks']}
\ , {'type': 'commands' , 'header': ['      Commands']}
\ ]

" Define bookmarks and commands
" Remember that Startify uses h, j, k, l, e, i, q, b, s, v, and t.
let g:startify_bookmarks =
\ [ {'n': '~/.config/nixpkgs/configs/nvim/init.vim'}
\ , {'c': '~/.config/nixpkgs/configs/nvim/coc-settings.json'}
\ ]
let g:startify_commands =
\ [ {'t': ['Open Terminal',  'term']}
\ ]

" Have DevIcons show up in Startify
function! StartifyEntryFormat()
  return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction
" }}}

" Terminal {{{
" ========

augroup nvimTerm
  au!
  " Set options for terminal buffers
  au TermOpen * if &buftype == 'terminal' | :startinsert | :setlocal nonumber | :setlocal norelativenumber | :setlocal signcolumn=no | endif
  " Make sure working directory of terminal buffer matches working directory of shell
  au BufEnter * call Set_term_pwd()
augroup END

let g:term_pwds = {}
function Set_term_pwd() abort
  if &buftype == 'terminal' && exists('g:term_pwds[b:terminal_job_pid]')
    execute 'lchd ' . g:term_pwds[b:terminal_job_pid]
    execute 'file term: ' . g:term_pwds[b:terminal_job_pid] . ' [' . b:terminal_job_pid . ']'
    execute 'AirlineRefresh!'
  endif
endfunction

" Floating terminal
" https://github.com/voldikss/vim-floaterm
let g:floaterm_title = 'Terminal ($1/$2)'
let g:floaterm_borderchars = ['─', '│', '─', '│', '╭', '╮', '╯', '╰']
" let g:floaterm_borderchars = ['━', '┃', '━', '┃', '┏', '┓', '┛', '┗']
" }}}

" Coc.nvim {{{
" =======

" Vim setting recommended by Coc.nvim
set hidden         " if not set, TextEdit might fail
set nobackup       " some lang servers have issues with backups, should be default, set just in case
set nowritebackup
set updatetime=300 " smaller update time for CursorHold and CursorHoldI
set shortmess+=c   " don't show ins-completion-menu messages.

" Extensions to load
let g:coc_global_extensions =
\ [ 'coc-fish'
\ , 'coc-import-cost'
\ , 'coc-sh'
\ ]

" Custom configuration home
let g:coc_config_home = $HOME . '/.config/nixpkgs/configs/nvim/'

" Other basic Coc.nvim config
let g:coc_status_error_sign   = error_symbol
let g:coc_status_warning_sign = warning_symbol
let g:markdown_fenced_languages = ['vim', 'help', 'haskell', 'bash=sh', 'nix']

" Autocommands
augroup coc_autocomands
  au!
  " Setup formatexpr specified filetypes (default binding is gq)
  au FileType typescript,json,haskell,purescript,python,nix setl formatexpr=CocAction('formatSelected')
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
hi link HighlightedyankRegion Visual
hi link CocFloating CursorLine
" }}}

" Linter/Fixer {{{
" ============
" Asyncronous Linting Engine (ALE)
" Used for linting when no good language server is available
" https://github.com/w0rp/ale

" Disable linters for languages that have defined language servers above
let g:ale_linters =
\ { 'c'         : []
\ , 'fish'      : []
\ , 'haskell'   : []
\ , 'idris'     : ['idris']
\ , 'json'      : []
\ , 'javascript': []
\ , 'lua'       : []
\ , 'python'    : []
\ , 'purescript': []
\ , 'sh'        : []
\ , 'typescript': []
\ , 'vim'       : []
\ , 'yaml'      : []
\ }

" Language specific options
let g:ale_idris_options = '--total --warnpartial --warnreach --warnipkg'

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
  au FileType markdown,mkd,text call pencil#init() | setlocal spell
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

" editorconfig-vim
" https://EditorConfig.org
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" }}}

" Keybindings {{{
" ===========

let mapleader = '`'

" Terminal
" enter normal mode in terminal
tnoremap <ESC> <C-\><C-n>
" send escape to terminal
tnoremap <leader><ESC> <ESC>
" floating terminal
function! s:floatermKeybindings() abort
  map <buffer><silent><space>tn <Cmd>FloatermNew<CR>
  map <buffer><silent><space>tl <Cmd>FloatermNext<CR>
  map <buffer><silent><space>th <Cmd>FloatermPrev<CR>
  map <buffer><silent><space>tq <Cmd>FloatermKill<CR>
  nmap <buffer><silent><ESC> <Cmd>FloatermToggle<CR>
  return
endfunction
augroup floatTermKeybinding
  au!
  au FileType floaterm call <SID>floatermKeybindings()
augroup END
map <silent><space><space> <Cmd>FloatermToggle<CR>

" Tab creation/destruction
map <silent><space>tn <Cmd>tabnew +Startify<CR>
map <silent><space>to <Cmd>tabonly<CR>
map <silent><space>tq <Cmd>tabclose<CR>

" Tab navigation
map <silent><space>tl <Cmd>tabnext<CR>
map <silent><space>th <Cmd>tabprevious<CR>

" Split creation/destruction
map <silent><space>_  <Cmd>new +term<CR>
map <silent><space>-  <Cmd>botright new +term<CR>
map <silent><space>\  <Cmd>vnew +term<CR>
map <silent><space>\| <Cmd>botright vnew +term<CR>
map <silent><space>ws <Cmd>split<CR>
map <silent><space>wv <Cmd>vsplit<CR>
map <silent><space>wq <Cmd>q<CR>
map <silent><space>wo <Cmd>only<CR>

" Split navigation
map <silent><space>wk <Cmd>wincmd k<CR>
map <silent><space>wj <Cmd>wincmd j<CR>
map <silent><space>wh <Cmd>wincmd h<CR>
map <silent><space>wl <Cmd>wincmd l<CR>
map <silent><space>wp <Cmd>wincmd p<CR>
map <silent><space>wc <Cmd>call ActiveChooseWin()<CR>
map <silent><space>wz <Cmd>ZoomWinTabToggle<CR>

" Split movement
map <silent><space>mk <C-w>K
map <silent><space>mj <C-w>J
map <silent><space>mh <C-w>H
map <silent><space>ml <C-w>L
map <silent><space>mt <C-w>T
map <silent><space>mr <C-w>r
map <silent><space>mR <C-w>R
map <silent><space>mx <C-w>x
map <silent><space>ms <Cmd>call ActiveChooseWin()<CR>s

" Various quit/close commands
map <silent><space>qw <Cmd>q<CR>
map <silent><space>qt <Cmd>tabclose<CR>
map <silent><space>qh <Cmd>helpclose<CR>
map <silent><space>qp <Cmd>pclose<CR>
map <silent><space>qc <Cmd>cclose<CR>


" Git
" vim-fugitive
map <silent><space>gb  <Cmd>Gblame<CR>
map <silent><space>gs  <Cmd>Gstatus<CR>
map <silent><space>gds <Cmd>Ghdiffsplit<CR>
map <silent><space>gdv <Cmd>Gvdiffsplit<CR>
" coc-nvim (coc-git)
map <silent><space>gw  <Cmd>CocCommand git.browserOpen<CR>
map <silent><space>gcd <Plug>(coc-git-chunkinfo)
map <silent><space>gcn <Plug>(coc-git-nextchunk)
map <silent><space>gcN <Plug>(coc-git-prevchunk)
map <silent><space>gcs <Cmd>CocCommand git.chunkStage<CR>
map <silent><space>gcu <Cmd>CocCommand git.chunkUndo<CR>
map <silent><space>glb <Cmd>CocList branches<CR>
map <silent><space>glc <Cmd>CocList commits<CR>
map <silent><space>gli <Cmd>CocList issues<CR>
map <silent><space>gls <Cmd>CocList gstatus<CR>

" Language server (coc-nvim)
" actions
map <silent><space>la <Plug>(coc-codeaction)
map <silent><space>lA <Cmd>CocList actions<CR>
map <silent><space>lc <Plug>(coc-codelens-action)
map <silent><space>lq <Plug>(coc-fix-current)
map <silent><space>lf <Plug>(coc-format-selected)
map <silent><space>lf <Plug>(coc-format)
map <silent><space>lr <Plug>(coc-rename)
" goto
map <silent><space>ln <Plug>(coc-diagnostic-next)
map <silent><space>lN <Plug>(coc-diagnostic-prev)
map <silent><space>ld <Plug>(coc-definition)
map <silent><space>lD <Plug>(coc-declaration)
map <silent><space>li <Plug>(coc-implementation)
map <silent><space>lt <Plug>(coc-type-definition)
map <silent><space>lR <Plug>(coc-references)
" hover/docs
map <silent><space>lh :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" lists
map <silent><space>ls <Cmd>CocList symbols<CR>
map <silent><space>le <Cmd>CocList diagnostics<CR>

" List search (coc-nvim)
" coc meta lists
map <silent><space>scc <Cmd>CocList commands<CR>
map <silent><space>sce <Cmd>CocList extensions<CR>
map <silent><space>scl <Cmd>CocList lists<CR>
map <silent><space>scs <Cmd>CocList sources<CR>
" buffers
map <silent><space>sb  <Cmd>CocList buffers<CR>
" files
" TODO: find easy way to search hidden files (in Denite prepending with "." works)
" TODO: find a way to move up path
map <silent><space>sf  <Cmd>CocList files<CR>
map <silent><space>sp  <Cmd>CocList files -F<CR>
" filetypes
map <silent><space>st  <Cmd>CocList filetypes<CR>
" grep
map <silent><space>sg  <Cmd>CocList --interactive grep -F<CR>
map <silent><space>sw  <Cmd>execute "CocList --interactive --input=".expand("<cword>")." grep -F"<CR>
" help tags
map <silent><space>s?  <Cmd>CocList helptags<CR>
" lines of buffer
map <silent><space>sl  <Cmd>CocList lines<CR>
map <silent><space>s*  <Cmd>execute "CocList --interactive --input=".expand("<cword>")." lines"<CR>
" maps
map <silent><space>sm  <Cmd>CocList maps<CR>
" search history
map <silent><space>ss  <Cmd>CocList searchhistory<CR>
" Vim commands
map <silent><space>sx  <Cmd>CocList vimcommands<CR>
" Vim commands history
map <silent><space>sh  <Cmd>CocList cmdhistory<CR>
" yank history
map <silent><space>sy  <Cmd>CocList --normal yank<CR>
" resume previous search
map <silent><space>sr  <Cmd>CocListResume<CR>

" Use tab to navigate completion menu and jump in snippets
" Pressing Tab goes to next completion of list is open, opens completion list if not preceded by
" space, and inserts a Tab otherwise.
inoremap <silent><expr> <Tab>
\ pumvisible()
\ ? "\<C-n>"
\ : <SID>check_back_space()
\   ? "\<Tab>"
\   : coc#refresh()
" Pressing Shift-Tab navigates backwards through completion list
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction


" Use <CR> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" }}}
