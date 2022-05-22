-- Colorscheme build in Lua with `lush.nvim`, modeled initially on Solarized, but intended to be
-- usable with alternate colors.
-- Still early days, with lots of work needed
-- https://github.com/rktjmp/lush.nvim
local lush = require 'lush'
local hsl = lush.hsl
local seq = require 'pl.seq'

local M = {}

-- Default colors are the Solarized colors
M.colors = {
  darkBase     = hsl '#002b36', -- base03
  darkBaseHl   = hsl '#073642', -- base02
  darkestTone  = hsl '#586e75', -- base01
  darkTone     = hsl '#657b83', -- base00
  lightTone    = hsl '#839496', -- base0
  lightestTone = hsl '#93a1a1', -- base1
  lightBaseHl  = hsl '#eee8d5', -- base2
  lightBase    = hsl '#fdf6e3', -- base3
  yellow       = hsl '#b58900',
  orange       = hsl '#cb4b16',
  red          = hsl '#dc322f',
  magenta      = hsl '#d33682',
  violet       = hsl '#6c71c4',
  blue         = hsl '#268bd2',
  cyan         = hsl '#2aa198',
  green        = hsl '#859900',
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
