-- Import required globals
-- galaxyline.nvim
-- https://github.com/glepnir/galaxyline.nvim
vim.cmd 'packadd! galaxyline-nvim'
local gl = require 'galaxyline'
local gls = gl.section

local s =  require 'utils'.symbols
local _ = require 'moses'

-- Module
local M = {}

function M.setStatusLine ()
  local c = _.map(require'MaloSolarized'.colors, function(v) return v.hex end)

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
        highlight = { c.green, c.base }
      }
    },
    {
      ViMode = {
        provider = function()
          local alias = {
            c = '  ' .. s.term .. ' ',
            i = '  ' .. s.pencil .. ' ',
            n = '  ' .. s.vim .. ' ',
            t = '  ' .. s.term .. ' ',
            v = '  ' .. s.ibar .. ' ',
            V = '  ' .. s.ibar .. ' ',
            [''] = s.ibar .. ' ',
          }
          return alias[vim.fn.mode()]
        end,
        separator = s.sepRoundRight .. ' ',
        separator_highlight = { c.green , c.basehl },
        highlight = { c.lightBase, c.green, 'bold' },
      }
    },
    {
      FileIcon = {
        provider = 'FileIcon',
        condition = buffer_not_empty,
        highlight = { require('galaxyline.provider_fileinfo').get_file_icon_color , c.basehl },
      }
    },
    {
      FileName = {
        provider = { 'FileName', 'FileSize' },
        condition = buffer_not_empty,
        highlight = { c.gray, c.basehl, 'italic' }
      }
    },
    {
      GitStart = {
        provider = _.constant(s.sepRoundLeft),
        condition = require('galaxyline.provider_vcs').check_git_workspace,
        highlight = { c.base, c.basehl }
      }
    },
    {
      GitBranch = {
        provider = 'GitBranch',
        condition = buffer_not_empty,
        icon = '  ' .. s.gitBranch .. ' ',
        highlight = { c.main , c.base, 'bold' },
      }
    },
    {
      DiffAdd = {
        provider = 'DiffAdd',
        condition = checkwidth,
        icon = ' ',
        highlight = { c.green , c.base },
      }
    },
    {
      DiffModified = {
        provider = 'DiffModified',
        condition = checkwidth,
        icon = ' ',
        highlight = { c.yellow , c.base },
      }
    },
    {
      DiffRemove = {
        provider = 'DiffRemove',
        condition = checkwidth,
        icon = ' ',
        highlight = { c.red, c.base },
      }
    },
    {
      GitEnd = {
        provider = _.constant(s.sepRoundRight),
        condition = require('galaxyline.provider_vcs').check_git_workspace,
        highlight = { c.base, c.basehl }
      }
    },
    {
      LeftEnd = {
        provider = _.constant(' '),
        highlight = { c.basehl, c.basehl }
      }
    },
  }

  gls.right = {
    {
      DiagnosticError = {
        provider = 'DiagnosticError',
        icon = ' ' .. s.errorShape .. ' ',
        highlight = { c.red , c.basehl }
      }
    },
    {
      DiagnosticWarn = {
        provider = 'DiagnosticWarn',
        icon = '  ' .. s.warningShape .. ' ',
        highlight = { c.yellow, c.basehl },
      }
    },
    {
      DiagnosticInfo = {
        provider = 'DiagnosticInfo',
        icon = '  ' .. s.infoShape .. ' ',
        highlight = { c.main, c.basehl },
      }
    },
    {
      DiagnosticHint = {
        provider = 'DiagnosticHint',
        icon = '  ' .. s.questionShape .. ' ',
        highlight = { c.main, c.basehl },
      }
    },
    {
      LineInfo = {
        provider = 'LineColumn',
        separator = ' ' .. s.sepRoundLeft,
        icon = ' ',
        separator_highlight = { c.green , c.basehl },
        highlight = { c.lightBase , c.green },
      }
    },
    {
      PerCent = {
        provider = 'LinePercent',
        separator = ' ',
        separator_highlight = { c.darkBase, c.green },
        highlight = { c.lightBase , c.green },
      }
    },
    {
      ScrollBar = {
        provider = 'ScrollBar',
        highlight = { c.lightBase , c.green },
      }
    },
    {
      LastElement = {
        provider = _.constant(s.sepRoundRight),
        highlight = { c.green , c.base }
      }
    }
  }

  gls.short_line_left = {
    {
      ShortFirstElement = {
        provider = _.constant(s.sepRoundLeft),
        highlight = { c.basehl , c.base }
      }
    },
    {
      ShortFileIcon = {
        provider = 'FileIcon',
        condition = buffer_not_empty,
        highlight = { c.main , c.basehl },
      }
    },
    {
      ShortFileName = {
        provider = { 'FileName', 'FileSize' },
        condition = buffer_not_empty,
        highlight = { c.main, c.basehl }
      }
    }
  }

  gls.short_line_right = {
    {
      ShortLastElement = {
        provider = _.constant(s.sepRoundRight),
        highlight = { c.basehl, c.base }
      }
    }
  }

  gl.init_colorscheme()
end

return M
