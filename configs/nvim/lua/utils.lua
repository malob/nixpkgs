-- Setup Environment -------------------------------------------------------------------------------

-- Create locals for all needed globals so we have access to them
local unpack = unpack
local vim = vim
local _ = require 'moses'

-- Clear environment
local _ENV = {}


-- Neovim Lua API aliases --------------------------------------------------------------------------

o = vim.o
bo = vim.bo
wo = vim.wo
b = vim.b
g = vim.g
hi = vim.highlight
cmd = vim.cmd
api = vim.api
fn = vim.fn
split = vim.split
env = vim.env
sign = {
  define = fn.sign_define
}


-- Helper functions -------------------------------------------------------------------------------

-- Useful function I which was in Moses
local function spread(f)
  return function(t) f(unpack(t)) end
end

---Helper for building keymap functions
---Where `f` should be one of `vim.api.nvim_set_keymap` or `vim.api.nvim_buf_set_keymap`, and `otps`
---is just a list of strings with the options that should be enabled.
---@type fun(f:fun(), mode:string, lhs:string, rhs:string, opts:string[])
local function _keymap (f, mode, lhs, rhs, opts)
  f(mode, lhs, rhs, _.mapi(opts, function(v) return v, true end))
end

---Helper for building keymap functions that make multiple mappings at onetime
---Where `f` should be one of `vim.api.nvim_set_keymap` or `vim.api.nvim_buf_set_keymap`, and `t` is
---a table of the form `{ mode = 'i', opts = { 'noremap', 'silent' }, maps = { { '[lhs]', '[rhs]' }  }}`
---@type fun(f:fun(), t:table)
local function _keymaps(f, t)
  _.eachi(t.maps, spread(_.partial(f, t.mode, '_', '_', t.opts)))
end


-- Convinience functions for working with Neovim API -----------------------------------------------

---Makes a global keymap
---`keymap(mode:string, lhs:string, rhs:string, opts:[string])`
---Where `opts` is a list of strings of the options to enable, e.g., `{ 'noremap', 'silent' }`.
keymap = _.partial(_keymap, api.nvim_set_keymap)

---Makes a keymap for the current buffer
---`bufkeymap(mode:string, lhs:string, rhs:string, opts:[string])`
---Where `opts` is a list of strings of the options to enable, e.g., `{ 'noremap', 'silent' }`.
bufkeymap = _.partial(_keymap, _.partial(api.nvim_buf_set_keymap, 0))

---Makes a collection of global keymaps with for the same mode with the same options
---`keymaps(t:{mode:string, opts:[string], maps:[[string]]})`
---Where `opts` is a list of strings of the options to enable, e.g., `{ 'noremap', 'silent' }`, and
---`maps` is a list of keymaps of the form `{ '[lhs]', '[rhs]' }`.
keymaps = _.partial(_keymaps, keymap)

---Makes a collection of global keymaps with for the same mode with the same options
---`keymaps(t:{mode:string, opts:[string], maps:[[string]]})`
---Where `opts` is a list of strings of the options to enable, e.g., `{ 'noremap', 'silent' }`, and
---`maps` is a list of keymaps of the form `{ '[lhs]', '[rhs]' }`.
bufkeymaps = _.partial(_keymaps, bufkeymap)

---Makes an autocommand group
---`augroup(t:{name:string, cmds:[[string]])`
---Where `cmds` is a list of autocommands of the form `{ '[event]', '[pattern]', '[cmd]' }`
function augroup (t)
  cmd('augroup ' .. t.name)
  cmd('au!')
  _.eachi(t.cmds, function(v) cmd('au ' .. _.concat(v, ' ')) end)
  cmd('augroup END')
end

---Commonly used symbols for easy access
symbol = {
  error = '',
  errorShape = '',
  gitBranch = '',
  ibar = '',
  info = '',
  infoShape = '',
  list = '',
  lock = '',
  pencil = '',
  question = '',
  questionShape = '',
  sepRoundLeft = '',
  sepRoundRight = '',
  spinner = '',
  term = '',
  vim = '',
  wand = '',
  warning = '',
  warningShape = '',
}

return _ENV
