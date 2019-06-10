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
"   * <leader>s for search (Denite) related commands.
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
set termguicolors             " truecolor support
let g:neosolarized_italic = 1
colorscheme NeoSolarized      " version of solarized that works better with truecolors
" terminal colors configured in ./neovim.nix
augroup termcolors
  au!
  au ColorScheme * call UpdateTermColors()
augroup END

" Misc basic vim ui config
set cursorline      " highlight current line
set linebreak       " soft wraps on words not individual chars
set noshowmode      " don't show --INSERT-- etc.
set colorcolumn=100 " show column boarder
set relativenumber  " relative line numbers
set signcolumn=yes  " always have signcolumn open to avoid thing shifting around all the time
set scrolloff=5     " start scrolling when cursor is within 5 lines of the edge

" Variables to reuse in config
let error_symbol   = ''
let warning_symbol = ''
let info_symbol    = ''
let pencil_symbol  = ''

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

" STATUS LINE {{{
" ===========
" https://github.com/vim-airline/vim-airline

" General configuration
let g:airline#parts#ffenc#skip_expected_string = 'utf-8[unix]' " only show unusual file encoding
let g:airline#extensions#hunks#non_zero_only   = 1             " only git stats when there are changes
let g:airline_skip_empty_sections              = 1             " don't show sections if they're empty

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
let g:airline_symbols.dirty     = pencil_symbol
let g:airline_mode_map =
\ { '__': '-'
\ , 'c' : ''
\ , 'i' : pencil_symbol
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
let airline#extensions#ale#error_symbol              = error_symbol.':'
let airline#extensions#ale#warning_symbol            = warning_symbol.':'
let airline#extensions#languageclient#error_symbol   = error_symbol.':'
let airline#extensions#languageclient#warning_symbol = warning_symbol.':'
let g:airline#extensions#quickfix#quickfix_text      = ''
let g:airline#extensions#quickfix#location_text      = ''

" Patch in missing colors for terminal status line
let g:airline_theme_patch_func = 'AirlineThemePatch'
function! AirlineThemePatch(palette)
  if g:airline_theme ==# 'solarized'
    for key in ['normal', 'insert', 'replace', 'visual', 'inactive']
      let a:palette[key].airline_term = a:palette[key].airline_x
    endfor
  endif
endfunction
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
\     , ' let nixRebuildOutput=system("nixuser-rebuild")
\       | let newVimConfig=system("nix-store --query --references (which nvim) | grep vimrc")
\       | execute "source" newVimConfig
\       | redraw
\       | echo nixRebuildOutput
\       '
\     ]
\   }
\ ]

" Run Startify in new tabs
" See keyboard mappings in next section
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

" LANGUAGE CLIENT {{{
" ===============
" LanguageClient-neovim
" Provides completions, linting, fixers, etc.
" https://github.com/autozimu/LanguageClient-neovim

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
\   , 'signText'  : warning_symbol
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

" Extend timeout
let g:LanguageClient_waitOutputTimeout = 20


augroup LC
  au!
  au CursorHold * call LanguageClient#isAlive(function('LspMaybeHighlight'))
  " au CursorHold * call LanguageClient#isAlive(function('LspMaybeHover'))
  au FileType   * call LC_maps()
augroup END

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

" Language server related keybindings
function! LC_maps() abort
  if has_key(g:LanguageClient_serverCommands, &filetype)
    set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
    call Anoremap('<buffer><silent>', '<leader>lh', '<Cmd>call LanguageClient#textDocument_hover()<CR>')
    " goto commands
    call Anoremap('<buffer><silent>', '<leader>ld', '<Cmd>call LanguageClient#textDocument_definition({"gotoCmd": "split"})<CR>')
    call Anoremap('<buffer><silent>', '<leader>lt', '<Cmd>call LanguageClient#textDocument_typeDefinition()<CR>')
    call Anoremap('<buffer><silent>', '<leader>li', '<Cmd>call LanguageClient#textDocument_implementation()<CR>')
    " formating commands
    call Anoremap('<buffer><silent>', '<leader>lf', '<Cmd>call LanguageClient#textDocument_formatting()<CR>')
    call Anoremap('<buffer><silent>', '<leader>lF', '<Cmd>call LanguageClient#textDocument_rangeFormatting()<CR>')
    " highlight commands
    call Anoremap('<buffer><silent>', '<leader>ll', '<Cmd>call LanguageClient#textDocument_documentHighlight()<CR>')
    call Anoremap('<buffer><silent>', '<leader>lL', '<Cmd>call LanguageClient#textDocument_clearDocumentHighlight()<CR>')
    " other commands
    call Anoremap('<buffer><silent>', '<leader>le', '<Cmd>call LanguageClient#explainErrorAtPoint()<CR>')
    call Anoremap('<buffer><silent>', '<leader>lr', '<Cmd>call LanguageClient#textDocument_rename()<CR>')
    call Anoremap('<buffer><silent>', '<leader>la', '<Cmd>call LanguageClient#workspace_applyEdit()<CR>')
    " Denite sources
    call Anoremap('<buffer><silent>', '<leader>lc', '<Cmd>Denite codeAction<CR>')
    call Anoremap('<buffer><silent>', '<leader>lm', '<Cmd>Denite contextMenu<CR>')
    call Anoremap('<buffer><silent>', '<leader>ls', '<Cmd>Denite documentSymbol<CR>')
    call Anoremap('<buffer><silent>', '<leader>lS', '<Cmd>Denite workspaceSymbol<CR>')
    call Anoremap('<buffer><silent>', '<leader>lx', '<Cmd>Denite references<CR>')
  endif
endfunction
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
let g:ale_sign_warning       = warning_symbol
let g:ale_sign_info          = info_symbol
let g:ale_sign_style_error   = pencil_symbol
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
  au FileType markdown,mkd,text call pencil#init() | set spell
augroup END

" tabular
" Helps vim-markdown with table formatting amoung other things
" https://github.com/godlygeek/tabular
"
" Goyo
" Distraction free writing mode for vim
" https://github.com/junegunn/goyo.vim
" }}}

" LIST SEARCHER {{{
" =============
" denite.vim
" Powerful list searcher
" https://github.com/Shougo/denite.nvim
augroup denite_settings
  au!
  au FileType denite        call s:denite_maps()
  au FileType denite-filter call deoplete#custom#buffer_option('auto_complete', v:false)
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

" MISC PLUGIN {{{
" ===========

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
