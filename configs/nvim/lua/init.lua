-- Add my personal helpers
local utils = require 'malo.utils'
local augroup = utils.augroup
local keymap = utils.keymap
local keymaps = utils.keymaps
local bufkeymaps = utils.bufkeymaps
local s = utils.symbols
local _ = require 'moses'

-- Add some aliases for Neovim Lua API
local o = vim.o
local wo = vim.wo
local g = vim.g
local cmd = vim.cmd
local env = vim.env

-- TODO --------------------------------------------------------------------------------------------

-- - Flesh out custom colorscheme
--   - Revisit Pmenu highlights:
--   - Experiment with `Diff` highlights to look more like `delta`'s output.
--   - Set `g:terminal_color` values.
--   - Decide on whether I want to include a bunch of language specific highlights
--   - Figure out what to do with `tree-sitter` highlights.
--   - Stretch
--     - Add more highlights for plugins I use, and other popular plugins.
--     - Create monotone variant, where one base color is supplied, and all colors are generate
--       based on transformations of that colors.
-- - Make tweaks to custom status line
--   - Find a way to dynamically display current LSP status/progress/messages.
--   - See if there's an easy way to show show Git sections when in terminal buffer.
--   - Revamp conditions for when segments are displayed
--   - A bunch of other small tweaks.
-- - Improve completions
--   - Try `compe-nvim`?
--   - Not currently satisfied with sorting and what gets included when.
--   - Add snippet support? Maybe with vim-vsnip?
-- - List searching with telescope.nvim.
--   - Improve workspace folder detection on my telescope.nvim extensions
-- - Other
--   - Figure out how to get Lua LSP to be aware Nvim plugins. Why aren't they on `package.path`?
--   - Play around with `tree-sitter`.
--   - Look into replacing floaterm-vim with vim-toggleterm.lua.
--   - Look into some keymaps defined with vim-which-key being slow to execute.


-- Basic Vim Config --------------------------------------------------------------------------------

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
if g.vscode == nil then
  augroup { name = 'VimBasics', cmds = {
    -- Check if file has changed on disk, if it has and buffer has no changes, reload it
    { 'BufEnter,FocusGained,CursorHold,CursorHoldI', '*', 'checktime' },
    -- Remove trailing whitespace before write
    { 'BufWritePre', '*', [[%s/\s\+$//e]] },
    -- Highlight yanked text
    { 'TextYankPost', '*', [[silent! lua vim.highlight.on_yank {higroup='Search', timeout=150}]] },
  }}
end


-- UI ----------------------------------------------------------------------------------------------

-- Set UI related options
o.termguicolors   = true
o.showmode        = false -- don't show -- INSERT -- etc.
wo.colorcolumn    = '100' -- show column boarder
wo.number         = true  -- display numberline
wo.relativenumber = true  -- relative line numbers
wo.signcolumn     = 'yes' -- always have signcolumn open to avoid thing shifting around all the time
o.fillchars       = 'stl: ,stlnc: ,vert:·,eob: ' -- No '~' on lines after end of file, other stuff

-- Set colorscheme
require'malo.theme'.extraLushSpecs = {
  'lush_theme.malo.nvim-bufferline-lua',
  'lush_theme.malo.statusline',
  'lush_theme.malo.telescope-nvim',
}
cmd 'colorscheme malo'


-- Terminal ----------------------------------------------------------------------------------------

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


-- WhichKey maps -----------------------------------------------------------------------------------

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
  h = { ':Lspsaga hover_doc'                  , 'Hover'                   },
  d = { 'v:lua.vim.lsp.buf.definition()'      , 'Jump to definition'      },
  D = { 'v:lua.vim.lsp.buf.declaration()'     , 'Jump to declaration'     },
  a = { ':Lspsaga code_action'                , 'Code action'             },
  f = { 'v:lua.vim.lsp.buf.formatting()'      , 'Format'                  },
  r = { ':Lspsaga rename'                     , 'Rename'                  },
  t = { 'v:lua.vim.lsp.buf.type_definition()' , 'Jump to type definition' },
  n = { ':Lspsaga diagnostic_jump_next'       , 'Jump to next diagnostic' },
  N = { ':Lspsaga diagnostic_jump_prev'       , 'Jump to prev diagnostic' },
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