-- vim: foldmethod=marker

-- Add my personal helpers
local utils = require 'utils'
local augroup = utils.augroup
local keymap = utils.keymap
local bufkeymap = utils.bufkeymap
local keymaps = utils.keymaps
local bufkeymaps = utils.bufkeymaps
local s = utils.symbols
local _ = require 'moses'

-- Add some aliases for Neovim Lua API
local o = vim.o
local wo = vim.wo
local b = vim.b
local bo = vim.bo
local g = vim.g
local cmd = vim.cmd
local env = vim.env

-- TODO ---------------------------------------------------------------------------------------- {{{

-- - Flesh out custom colorscheme
--   - Tweak `TabLine` highlights.
--   - Revisit Pmenu highlights:
--     - Many Vim plugins use this as the base for their popup/floating windows, since doesn't have
--       `NormalFloat` as a highlight. (At least I don't think it does).
--   - Experiment with `Diff` highlights to look more like `delta`'s output.
--   - Set `g:terminal_color` values.
--   - Finish defining highlights for internal LSP.
--   - Decide on whether I want to include a bunch of language specific highlights
--   - Figure out what to do with `tree-sitter` highlights.
--   - Stretch
--     - Add more highlights for plugins I use, and other popular plugins.
--     - Abstract away specific color choices. Make is so that it's easy to supply custom colors.
--     - Create monotone variant, where one base color is supplied, and all colors are generate
--       based on transformations of that colors.
-- - Make tweaks to custom status line
--   - Integrate better with colorscheme.
--   - Find a way to dynamically display current LSP status/progress/messages.
--   - See if there's an easy way to show show Git sections when in terminal buffer.
--   - Revamp conditions for when segments are displayed
--   - A bunch of other small tweaks.
-- - Improve completions
--   - Not currently satisfied with sorting and what gets included when.
--   - Add snippet support? Maybe with vim-vsnip?
-- - Bufferline/tabline
--   - Figure out whether I want to keep using nvim-bufferline.lua.
--   - Find something better or tweak it util I have something I like.
-- - List searching with telescope.nvim.
--   - Improve workspace folder detection on my telescope.nvim extensions
--   - Get around to making a Hoogle extention.
-- - Other
--   - Figure out how to get Lua LSP to be aware Nvim plugins. Why aren't they on `package.path`?
--   - Play around with `tree-sitter`.
--   - Look into replacing floaterm-vim with vim-toggleterm.lua.
--   - Look into some keymaps defined with vim-which-key being slow to execute.

-- }}}

-- Basic Vim Config ---------------------------------------------------------------------------- {{{

o.scrolloff  = 10   -- start scrolling when cursor is within 5 lines of the ledge
o.linebreak  = true -- soft wraps on words not individual chars
o.mouse      = 'a'  -- enable mouse support in all modes
o.updatetime = 300
o.autochdir  = true

-- Search and replace
o.ignorecase = true      -- make searches with lower case characters case insensative
o.smartcase  = true      -- search is case sensitive only if it contains uppercase chars
o.inccommand = 'nosplit' -- show preview in buffer while doing find and replace

-- Tab key behavior
o.expandtab  = true      -- Convert tabs to spaces
o.tabstop    = 2         -- Width of tab character
o.shiftwidth = o.tabstop -- Width of auto-indents

-- Set where splits open
o.splitbelow = true -- open horizontal splits below instead of above which is the default
o.splitright = true -- open vertical splits to the right instead of the left with is the default

-- Some basic autocommands
augroup { name = 'VimBasics', cmds = {
  -- Check if file has changed on disk, if it has and buffer has no changes, reload it
  { 'BufEnter,FocusGained,CursorHold,CursorHoldI', '*', 'checktime' },
  -- Remove trailing whitespace before write
  { 'BufWritePre', '*', [[%s/\s\+$//e]] },
  -- Highlight yanked text
  { 'TextYankPost', '*', [[silent! lua vim.highlight.on_yank {higroup='Search', timeout=150}]] },
}}

-- }}}

-- UI ------------------------------------------------------------------------------------------ {{{

-- Set UI related options
o.termguicolors   = true
o.showmode        = false -- don't show -- INSERT -- etc.
wo.colorcolumn    = '100' -- show column boarder
wo.cursorline     = true  -- highlight current line
wo.number         = true  -- display numberline
wo.relativenumber = true  -- relative line numbers
wo.signcolumn     = 'yes' -- always have signcolumn open to avoid thing shifting around all the time
o.fillchars       = 'stl: ,stlnc: ,vert:·,eob: ' -- No '~' on lines after end of file, and other stuff

-- Add personal hacks
augroup { name = 'ColorschemeHacks', cmds = {
  { 'ColorScheme', '*', [[lua require'statusline'.setStatusLine()]] },
}}

-- Set colorscheme
cmd 'colorscheme MaloSolarized'

-- Tabline
-- nvim-bufferline.lua
-- https://github.com/akinsho/nvim-bufferline.lua
require'bufferline'.setup {
  options = {
    view = 'multiwindow',
    separator_style = 'slant',
    diagnostics = 'nvim_lsp',
    diagnostics_indicator = function(_, level)
      local icon = level:match('error') and s.errorShape or s.warningShape
      return ' ' .. icon
    end,
  },
}
-- Colors are taken care of directly in colorscheme
cmd 'au! BufferlineColors ColorScheme'

-- Git signs
-- gitsigns.nvim
-- https://github.com/lewis6991/gitsigns.nvim
cmd 'packadd! gitsigns-nvim'
require'gitsigns'.setup {
  signs = {
    add          = { hl = 'GitAddSign'          , text = '┃' , numhl='' },
    change       = { hl = 'GitChangeSign'       , text = '┃' , numhl='' },
    delete       = { hl = 'GitDeleteSign'       , text = '_' , numhl='' },
    topdelete    = { hl = 'GitDeleteSign'       , text = '‾' , numhl='' },
    changedelete = { hl = 'GitChangeDeleteSign' , text = '≃' , numhl='' },
  },
  numhl = false,
  keymaps = {},
  watch_index = {
    interval = 1000
  },
  sign_priority = 6,
  status_formatter = nil, -- Use default
}

-- }}}

-- Terminal ------------------------------------------------------------------------------------ {{{

augroup { name = 'NeovimTerm', cmds = {
  -- Set options for terminal buffers
  { 'TermOpen', '*', 'setlocal nonumber | setlocal norelativenumber | setlocal signcolumn=no' },
}}

-- Leader only used for this one case
g.mapleader = '`'
keymaps { mode = 't', opts = { 'noremap' }, maps = {
  -- Enter normal mode in terminal using `<ESC>` like everywhere else.
  { '<ESC>', [[<C-\><C-n>]] },
  -- Sometimes you want to send `<ESC>` to the terminal though.
  { '<leader><ESC>', '<ESC>' },
}}

-- Floating terminal
-- https://github.com/voldikss/vim-floaterm
-- Plugin loaded on first used keybinding in WhichKey section
g.floaterm_title       = 'Terminal ($1/$2)'
g.floaterm_borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' }
g.floaterm_width       = 0.8
g.floaterm_height      = 0.8

function FloatTermKeymaps ()
  bufkeymaps { mode = '',  opts = { 'silent' }, maps = {
    { '<Space>tn' , ':FloatermNew<CR>'    },
    { '<Space>tl' , ':FloatermNext<CR>'   },
    { '<Space>th' , ':FloatermPrev<CR>'   },
    { '<Space>tq' , ':FloatermKill<CR>'   },
    { '<ESC>'     , ':FloatermToggle<CR>' },
  }}
end

augroup { name = 'FloatTermKeyMaps', cmds = {
  { 'FileType', 'floaterm', 'lua FloatTermKeymaps()' }
}}

-- }}}

-- Completions --------------------------------------------------------------------------------- {{{

-- Options
o.completeopt = 'menuone,noinsert,noselect'
o.shortmess   = vim.o.shortmess .. 'c' -- don't show extra message when using completion

-- completion-nvim
-- https://github.com/nvim-lua/completion-nvim
cmd 'packadd! completion-nvim'
cmd 'packadd! completion-buffers'
cmd 'packadd! completion-tabnine'

-- Use <Tab> and <S-Tab> to navigate through popup menu
keymaps { mode = 'i', opts = { 'noremap', 'expr' }, maps = {
  { '<Tab>'   , [[pumvisible() ? "\<C-n>" : "\<Tab>"]]   },
  { '<S-Tab>' , [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]] },
}}

-- How completions are sorted
g.completion_sorting = 'length' -- possible value: "length", "alphabet", "none"
-- completion-nvim will loop through the list and assign priority from high to low
g.completion_matching_strategy_list = { 'exact', 'substring', 'fuzzy', 'all' }
g.completion_matching_smart_case    = 1
g.completion_trigger_keyword_length = 3
g.completion_trigger_on_delete      = 1

g.completion_tabnine_max_num_results = 10

-- Specify which completiions are available
g.completion_chain_complete_list = {
  { complete_items = { 'lsp', 'path', 'snippet', 'tabnine' } },
  { mode = '<C-p>' },
  { mode = '<C-n>' },
}

-- Use completion-nvim with every buffer
augroup { name = 'Completions', cmds = {
  { 'BufEnter', '*', [[lua require'completion'.on_attach()]] },
}}

-- }}}

-- List Searcher ------------------------------------------------------------------------------- {{{

cmd 'packadd! telescope-nvim'
cmd 'packadd! telescope-symbols-nvim'
cmd 'packadd! telescope-z-nvim'
local telescope = require 'telescope'
local actions = require 'telescope.actions'
local previewers = require 'telescope.previewers'
telescope.setup {
  defaults = {
    prompt_prefix = '❯',
    color_devicons = true,
    file_previewer = previewers.vim_buffer_cat.new,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
    mappings = {
      n = {
        ['<CR>'] = actions.select_default + actions.center,
        s = actions.select_horizontal,
        v = actions.select_vertical,
        t = actions.select_tab,
        j = actions.move_selection_next,
        k = actions.move_selection_previous,
        u = actions.preview_scrolling_up,
        d = actions.preview_scrolling_down,
      },
    },
  },
}
telescope.load_extension 'builtin_extensions'
telescope.load_extension 'z'

--- }}}

-- Language Server Configs --------------------------------------------------------------------- {{{

-- Show LSP diagnostics in popups on cursor hold, not in virtual text
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    update_in_insert = false,
  }
)
augroup { name = 'LSP', cmds = {
  { 'CursorHold', '*', 'lua vim.lsp.diagnostic.show_line_diagnostics()' }
}}

-- Configure available LSPs
-- Note that all language servers aside from `sumneko_lua` are installed via Nix. See:
-- `../../../home/neovim.nix`.
vim.cmd 'packadd! nvim-lspconfig'
local lspconf = require 'lspconfig'

lspconf.bashls.setup {}
lspconf.ccls.setup {}
lspconf.hls.setup {}
lspconf.jsonls.setup {}
lspconf.rnix.setup {}

-- Fix for `nvim-lspconfig` no longer handling installing language servers
local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
end
local sumneko_root_path = vim.fn.stdpath('cache')..'/lspconfig/sumneko_lua/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"
lspconf.sumneko_lua.setup {
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      intelliSense = {
        searchDepth = 10
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [env.VIMRUNTIME .. '/lua'] = true,
          [env.VIMRUNTIME .. '/lua/vim/lsp'] = true,
        },
        maxPreload = 2000,
        preloadFileSize = 1000,
      },
    },
  },
}

lspconf.tsserver.setup {}

lspconf.vimls.setup {
  init_options = {
    iskeyword = '@,48-57,_,192-255,-#',
    vimruntime = env.VIMRUNTIME,
    runtimepath = o.runtimepath,
    diagnostic = {
      enable = true,
    },
    indexes = {
      runtimepath = true,
      gap = 100,
      count = 8,
      projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
    },
    suggest = {
      fromRuntimepath = true,
      fromVimruntime = true
    },
  }
}

lspconf.yamlls.setup {
  settings = {
    yaml = {
      format = {
        printWidth = 100,
        singleQuote = true,
      },
    },
  },
}

_{
  { 'LspDiagnosticsSignError', { text = s.error, texthl = 'LspDiagnosticsSignError' } },
  { 'LspDiagnosticsSignWarning', { text = s.warning, texthl = 'LspDiagnosticsSignWarning' } },
  { 'LspDiagnosticsSignInformation', { text = s.info, texthl = 'LspDiagnosticsSignInformation' } },
  { 'LspDiagnosticsSignHint', { text = s.question, texthl = 'LspDiagnosticsSignHint' } },
}:eachi(function(v) vim.fn.sign_define(unpack(v)) end)

-- }}}

-- Filetype specific --------------------------------------------------------------------------- {{{

-- nvim-treesitter
-- https://github.com/nvim-treesitter/nvim-treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = { enable = true },
  incremental_selection = { enable = true },
  indent = { enable = true },
}

-- Most filetypes
-- vim-polyglot
-- A solid language pack for Vim
-- https://github.com/sheerun/vim-polyglot

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
o.conceallevel=2

-- }}}

-- Misc ---------------------------------------------------------------------------------------- {{{

-- vim-pencil
-- Adds a bunch of really nice features for writing
-- https://github.com/reedes/vim-pencil
g['pencil#wrapModeDefault'] = 'soft' -- default is 'hard'
augroup { name = 'Pencil', cmds = {
  { 'FileType', 'markdown,mkd,text', 'packadd vim-pencil | call pencil#init() | setlocal spell' }
}}

-- Goyo
-- Distraction free writing mode for vim
-- https://github.com/junegunn/goyo.vim
-- vim-fugitive
-- A Git wrapper so awesome, it should be illegal
-- https://github.com/tpope/vim-fugitive

-- tabular
-- Helps vim-markdown with table formatting amoung many other things
-- https://github.com/godlygeek/tabular

-- vim-commentary
-- Comment stuff out (easily)
-- https://github.com/tpope/vim-commentary

-- vim-surround
-- Quoting/parenthesizing made simple
-- https://github.com/tpope/vim-surround

-- editorconfig-vim
-- https://EditorConfig.org
g.EditorConfig_exclude_patterns = { 'fugitive://.*' }

-- }}}

-- WhichKey maps ------------------------------------------------------------------------------- {{{

-- Define all `<Space>` prefixed keymaps with vim-which-key
-- https://github.com/liuchengxu/vim-which-key
cmd 'packadd! vim-which-key'
vim.fn['which_key#register']('<Space>', 'g:which_key_map')
keymap( '', '<Space>', [[:WhichKey '<Space>'<CR>]], { 'noremap', 'silent' } )

-- Display popup float full width
g.which_key_disable_default_offset = 1


-- Define maps
local whichKeyMap = {}

whichKeyMap[' '] = { ':packadd vim-floaterm | FloatermToggle', 'Toggle floating terminal' }

-- Tabs
whichKeyMap.t = {
  name = '+Tabs',
  n = { ':tabnew +term' , 'New with terminal' },
  o = { 'tabonly'       , 'Close all other'   },
  q = { 'tabclose'      , 'Close'             },
  l = { 'tabnext'       , 'Next'              },
  h = { 'tabprevious'   , 'Previous'          },
}

-- Windows/splits
whichKeyMap['-']  = { ':new +term'           , 'New terminal below'               }
whichKeyMap['_']  = { ':botright new +term'  , 'New termimal below (full-width)'  }
whichKeyMap['\\'] = { ':vnew +term'          , 'New terminal right'               }
whichKeyMap['|']  = { ':botright vnew +term' , 'New termimal right (full-height)' }
whichKeyMap.w = {
  name = '+Windows',
  -- Split creation
  s = { 'split'  , 'Split below'     },
  v = { 'vsplit' , 'Split right'     },
  q = { 'q'      , 'Close'           },
  o = { 'only'   , 'Close all other' },
  -- Navigation
  k = { ':wincmd k' , 'Go up'           },
  j = { ':wincmd j' , 'Go down'         },
  h = { ':wincmd h' , 'Go left'         },
  l = { ':wincmd l' , 'Go right'        },
  w = { ':wincmd w' , 'Go down/right'   },
  W = { ':wincmd W' , 'Go up/left'      },
  t = { ':wincmd t' , 'Go top-left'     },
  b = { ':wincmd b' , 'Go bottom-right' },
  p = { ':wincmd p' , 'Go to previous'  },
  -- Movement
  K = { ':wincmd k' , 'Move to top'              },
  J = { ':wincmd J' , 'Move to bottom'           },
  H = { ':wincmd H' , 'Move to left'             },
  L = { ':wincmd L' , 'Move to right'            },
  T = { ':wincmd T' , 'Move to new tab'          },
  r = { ':wincmd r' , 'Rotate clockwise'         },
  R = { ':wincmd R' , 'Rotate counter-clockwise' },
  z = { ':packadd zoomwintab-vim | ZoomWinTabToggle', 'Toggle zoom' },
  -- Resize
  ['='] = { ':wincmd ='            , 'All equal size'   },
  ['-'] = { ':resize -5'           , 'Decrease height'  },
  ['+'] = { ':resize +5'           , 'Increase height'  },
  ['<'] = { '<C-w>5<'              , 'Decrease width'   },
  ['>'] = { '<C-w>5>'              , 'Increase width'   },
  ['|'] = { ':vertical resize 106' , 'Full line-lenght' },
}

-- Git
whichKeyMap.g = {
  name = '+Git',
  -- vim-fugitive
  b = { 'Gblame'  , 'Blame'  },
  s = { 'Gstatus' , 'Status' },
  d = {
    name = '+Diff',
    s = { 'Ghdiffsplit' , 'Split horizontal' },
    v = { 'Gvdiffsplit' , 'Split vertical'   },
  },
  -- gitsigns.nvim
  h = {
    name = '+Hunks',
    s = { "v:lua.require('gitsigns').stage_hunk()"      , 'Stage'      },
    u = { "v:lua.require('gitsigns').undo_stage_hunk()" , 'Undo stage' },
    r = { "v:lua.require('gitsigns').reset_hunk()"      , 'Reset'      },
    n = { "v:lua.require('gitsigns').next_hunk()"       , 'Go to next' },
    N = { "v:lua.require('gitsigns').prev_hunk()"       , 'Go to prev' },
    p = { "v:lua.require('gitsigns').preview_hunk()"    , 'Preview'    },
  },
  -- telescope.nvim lists
  l = {
    name = '+Lists',
    s = { ':Telescope git_status'  , 'Status'         },
    c = { ':Telescope git_commits' , 'Commits'        },
    C = { ':Telescope git_commits' , 'Buffer commits' },
    b = { ':Telescope git_branches' , 'Branches'       },
  },
  -- Other
  v = { ':!gh repo view --web' , 'View on GitHub' },
}

-- Language server
whichKeyMap.l = {
  name = '+LSP',
  h = { 'v:lua.vim.lsp.buf.hover()'            , 'Hover'                   },
  d = { 'v:lua.vim.lsp.buf.definition()'       , 'Jump to definition'      },
  D = { 'v:lua.vim.lsp.buf.declaration()'      , 'Jump to declaration'     },
  a = { 'v:lua.vim.lsp.buf.code_action()'      , 'Code action'             },
  f = { 'v:lua.vim.lsp.buf.formatting()'       , 'Format'                  },
  r = { 'v:lua.vim.lsp.buf.rename()'           , 'Rename'                  },
  t = { 'v:lua.vim.lsp.buf.type_definition()'  , 'Jump to type definition' },
  n = { 'v:lua.vim.lsp.diagnostic.goto_next()' , 'Jump to next diagnostic' },
  N = { 'v:lua.vim.lsp.diagnostic.goto_prev()' , 'Jump to prev diagnostic' },
  l = {
    name = '+Lists',
    a = { ':Telescope lsp_code_actions'       , 'Code actions'         },
    A = { ':Telescope lsp_range_code_actions' , 'Code actions (range)' },
    r = { ':Telescope lsp_references'         , 'References'           },
    s = { ':Telescope lsp_document_symbols'   , 'Documents symbols'    },
    S = { ':Telescope lsp_workspace_symbols'  , 'Workspace symbols'    },
  },
}

-- Seaching with telescope.nvim
whichKeyMap.s = {
  name = '+Search',
  b = { ':Telescope file_browser'              , 'File Browser'           },
  f = { ':Telescope find_files_workspace'      , 'Files in workspace'     },
  F = { ':Telescope find_files'                , 'Files in cwd'           },
  g = { ':Telescope live_grep_workspace'       , 'Grep in workspace'      },
  G = { ':Telescope live_grep'                 , 'Grep in cwd'            },
  l = { ':Telescope current_buffer_fuzzy_find' , 'Buffer lines'           },
  o = { ':Telescope oldfiles'                  , 'Old files'              },
  t = { ':Telescope builtin'                   , 'Telescope lists'        },
  w = { ':Telescope grep_string_workspace'     , 'Grep word in workspace' },
  W = { ':Telescope grep_string'               , 'Grep word in cwd'       },
  v = {
    name = '+Vim',
    a = { ':Telescope autocommands'    , 'Autocommands'    },
    b = { ':Telescope buffers'         , 'Buffers'         },
    c = { ':Telescope commands'        , 'Commands'        },
    C = { ':Telescope command_history' , 'Command history' },
    h = { ':Telescope highlights'      , 'Highlights'      },
    q = { ':telescope quickfix'        , 'Quickfix list'   },
    l = { ':telescope loclist'         , 'Location list'   },
    m = { ':telescope keymaps'         , 'Keymaps'         },
    s = { ':telescope spell_suggest'   , 'Spell suggest'   },
    o = { ':telescope vim_options'     , 'Options'         },
    r = { ':Telescope registers'       , 'Registers'       },
    t = { ':Telescope filetypes'       , 'Filetypes'       },
  },
  s = { [[luaeval("require('telescope.builtin').symbols(require('telescope.themes').get_dropdown({sources = {'emoji', 'math'}}))")]], 'Symbols' },
  z = { [[luaeval("require'telescope'.extensions.z.list({cmd = {'fish', '-c', 'zq -ls'}})")]], 'Z' },
  ['?'] = { ':Telescope help_tags', 'Vim help' },
}

g.which_key_map = whichKeyMap

-- }}}
