-- Import required globals
-- galaxyline.nvim
-- https://github.com/glepnir/galaxyline.nvim
cmd('packadd! galaxyline-nvim')
local gl = require 'galaxyline'
local gls = gl.section
local vim = vim
local s = symbol
local _ = require 'moses'

-- Clear environment
local _ENV = {}

-- Module
local M = {}

function M.setStatusLine ()
  local c = {
    yellow = '#b58900',
    green  = '#719e07',
    blue   = '#268bd2',
    red    = '#dc322f',
    white  = '#fdf6e3',
    black  = '#002b36',
  }
  if o.background == 'light' then
    c.bg = c.white
    c.barbg = '#eee8d5'
    c.grey = '#586e75'
  else
    c.bg = c.black
    c.barbg = '#073642'
    c.grey = '#93a1a1'
  end

  local buffer_not_empty = function()
    if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
      return true
    end
    return false
  end

  local checkwidth = function()
    local squeeze_width  = vim.fn.winwidth(0) / 2
    if squeeze_width > 40 then
      return true
    end
    return false
  end

  gls.left = {
    {
      FirstElement = {
        provider = _.constant(s.sepRoundLeft),
        highlight = { c.green, c.bg }
      }
    },
    {
      ViMode = {
        provider = function()
          local alias = {
            c = '  ' .. symbol.term .. ' ',
            i = '  ' .. symbol.pencil .. ' ',
            n = '  ' .. symbol.vim .. ' ',
            t = '  ' .. symbol.term .. ' ',
            v = '  ' .. symbol.ibar .. ' ',
            V = '  ' .. symbol.ibar .. ' ',
            [''] = symbol.ibar .. ' ',
          }
          return alias[vim.fn.mode()]
        end,
        separator = s.sepRoundRight .. ' ',
        separator_highlight = { c.green , c.barbg },
        highlight = { c.white, c.green, 'bold' },
      }
    },
    {
      FileIcon = {
        provider = 'FileIcon',
        condition = buffer_not_empty,
        highlight = { require('galaxyline.provider_fileinfo').get_file_icon_color , c.barbg },
      }
    },
    {
      FileName = {
        provider = { 'FileName', 'FileSize' },
        condition = buffer_not_empty,
        separator = s.sepRoundLeft ,
        separator_highlight = { c.bg , c.barbg },
        highlight = { c.gray, c.barbg, 'italic' }
      }
    },
    {
      GitBranch = {
        provider = 'GitBranch',
        condition = buffer_not_empty,
        icon = ' ' .. s.gitBranch .. ' ',
        highlight = { c.grey , c.bg, 'bold' },
      }
    },
    {
      DiffAdd = {
        provider = 'DiffAdd',
        condition = checkwidth,
        icon = ' ',
        highlight = { c.green , c.bg },
      }
    },
    {
      DiffModified = {
        provider = 'DiffModified',
        condition = checkwidth,
        icon = ' ',
        highlight = { c.yellow , c.bg },
      }
    },
    {
      DiffRemove = {
        provider = 'DiffRemove',
        condition = checkwidth,
        icon = ' ',
        highlight = { c.red, c.bg },
      }
    },
    {
      LeftEnd = {
        provider = _.constant(s.sepRoundRight),
        highlight = { c.bg, c.barbg }
      }
    }
  }

  gls.right = {
    {
      DiagnosticError = {
        provider = 'DiagnosticError',
        icon = ' ' .. s.errorShape .. ' ',
        -- separator = ' ' ,
        highlight = { c.red , c.barbg }
      }
    },
    {
      DiagnosticWarn = {
        provider = 'DiagnosticWarn',
        icon = '  ' .. s.warningShape .. ' ',
        -- separator = ' ' ,
        highlight = { c.yellow, c.barbg },
      }
    },
    {
      DiagnosticInfo = {
        provider = 'DiagnosticInfo',
        icon = '  ' .. s.infoShape .. ' ',
        -- separator = ' ' ,
        highlight = { c.grey, c.barbg },
      }
    },
    {
      DiagnosticHint = {
        provider = 'DiagnosticHint',
        icon = '  ' .. s.questionShape .. ' ',
        highlight = { c.grey, c.barbg },
      }
    },
    {
      LineInfo = {
        provider = 'LineColumn',
        separator = ' ' .. s.sepRoundLeft,
        icon = ' ',
        separator_highlight = { c.green , c.barbg },
        highlight = { c.white , c.green },
      }
    },
    {
      PerCent = {
        provider = 'LinePercent',
        separator = ' ',
        separator_highlight = { c.white, c.green },
        highlight = { c.white , c.green },
      }
    },
    {
      ScrollBar = {
        provider = 'ScrollBar',
        highlight = { c.white , c.green },
      }
    },
    {
      LastElement = {
        provider = _.constant(s.sepRoundRight),
        highlight = { c.green , c.bg }
      }
    }
  }

  gls.short_line_left = {
    {
      ShortFirstElement = {
        provider = _.constant(s.sepRoundLeft),
        highlight = { c.barbg , c.bg }
      }
    },
    {
      ShortFileIcon = {
        provider = 'FileIcon',
        condition = buffer_not_empty,
        highlight = { c.grey , c.barbg },
      }
    },
    {
      ShortFileName = {
        provider = { 'FileName', 'FileSize' },
        condition = buffer_not_empty,
        highlight = { c.grey, c.barbg }
      }
    }
  }

  gls.short_line_right = {
    {
      ShortLastElement = {
        provider = _.constant(s.sepRoundRight),
        highlight = { c.barbg, c.bg }
      }
    }
  }

  gl.init_colorscheme()
end

return M
