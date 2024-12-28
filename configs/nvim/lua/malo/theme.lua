-- Colorscheme build in Lua with `lush.nvim`, modeled initially on Solarized, but intended to be
-- usable with alternate colors.
-- Still early days, with lots of work needed
-- https://github.com/rktjmp/lush.nvim
local lush = require 'lush'
local hsluv = lush.hsluv
local seq = require 'pl.seq'

local M = {}

-- Default colors are the Solarized colors
M.colors = {
  darkBase     = hsluv (vim.g.theme_base03 or '#002b36'),
  darkBaseHl   = hsluv (vim.g.theme_base02 or '#073642'),
  darkestTone  = hsluv (vim.g.theme_base01 or '#586e75'),
  darkTone     = hsluv (vim.g.theme_base00 or '#657b83'),
  lightTone    = hsluv (vim.g.theme_base0 or '#839496'),
  lightestTone = hsluv (vim.g.theme_base1 or '#93a1a1'),
  lightBaseHl  = hsluv (vim.g.theme_base2 or '#eee8d5'),
  lightBase    = hsluv (vim.g.theme_base3 or '#fdf6e3'),
  yellow       = hsluv (vim.g.theme_yellow or '#b58900'),
  orange       = hsluv (vim.g.theme_orange or '#cb4b16'),
  red          = hsluv (vim.g.theme_red or '#dc322f'),
  magenta      = hsluv (vim.g.theme_magenta or '#d33682'),
  violet       = hsluv (vim.g.theme_violet or '#6c71c4'),
  blue         = hsluv (vim.g.theme_blue or '#268bd2'),
  cyan         = hsluv (vim.g.theme_cyan or '#2aa198'),
  green        = hsluv (vim.g.theme_green or '#859900'),
}

-- A table of strings with the name of additonal Lush specs that should be merged with the
-- colorscheme.
M.extraLushSpecs = {}

-- Function called from `../colors/malo.vim` to load the colorscheme.
M.loadColorscheme = function ()
  vim.o.pumblend = 10
  vim.o.winblend = vim.o.pumblend

  -- We need to unload all Lush specs so that the specs are regenerated whenever the colorscheme is
  -- reapplied.
  package.loaded['lush_theme.malo'] = nil
  seq(M.extraLushSpecs):foreach(function(v) package.loaded[v] = nil end)

  -- Merge the main colorscheme spec with any additional specs that were provided.
  local finalSpec = lush.merge {
    require 'lush_theme.malo',
    lush.merge(seq(M.extraLushSpecs):map(require):copy())
  }

  -- Apply colorscheme
  lush(finalSpec)

  -- Set `nvim-web-devincons` highlights if they are in use
  if pcall(require, 'nvim-web-devicons') then require'nvim-web-devicons'.setup() end
end

return M
