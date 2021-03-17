-- Import required globals
-- galaxyline.nvim
-- https://github.com/glepnir/galaxyline.nvim
vim.cmd 'packadd! galaxyline-nvim'
local gl = require 'galaxyline'
local gls = gl.section
local condition = require 'galaxyline.condition'

local s =  require 'utils'.symbols
local _ = require 'moses'
-- Module
local M = {}

function M.setStatusLine ()
  local c = _.map(require'MaloSolarized'.colors, function(v) return v.hex end)

  gls.left = {
    {
      Mode = {
        provider = function()
          local alias = {
            c = s.term,
            i = s.pencil,
            n = s.vim,
            t = s.term,
            v = s.ibar,
            V = s.ibar,
            [''] = s.ibar,
          }
          return '  ' .. alias[vim.fn.mode()] .. ' '
        end,
        highlight = 'StatusLineGreenSection',
        separator = s.sepRoundRight .. ' ',
        separator_highlight = 'StatusLineGreen',
      }
    },
    {
      FileIcon = {
        provider = function ()
          vim.cmd('hi GalaxyFileIcon guifg='..require'galaxyline.provider_fileinfo'.get_file_icon_color()..' guibg='..c.basehl)
          return require'galaxyline.provider_fileinfo'.get_file_icon()
        end,
        condition = condition.buffer_not_empty,
        highlight = {},
      }
    },
    {
      FileName = {
        provider = 'FileName',
        condition = condition.buffer_not_empty,
        highlight = 'StatusLineItalic',
      }
    },
    {
      GitBranch = {
        provider = 'GitBranch',
        condition = condition.buffer_not_empty,
        icon = '  ' .. s.gitBranch .. ' ',
        highlight = 'StatusLineBold',
      }
    },
    {
      DiffAdd = {
        provider = 'DiffAdd',
        condition = condition.hide_in_width,
        icon = ' ',
        highlight = 'StatusLineGreen',
      }
    },
    {
      DiffModified = {
        provider = 'DiffModified',
        condition = condition.hide_in_width,
        icon = ' ',
        highlight = 'StatusLineYellow',
      }
    },
    {
      DiffRemove = {
        provider = 'DiffRemove',
        condition = condition.hide_in_width,
        icon = ' ',
        highlight = 'StatusLineRed',
      }
    },
  }

  gls.right = {
    {
      DiagnosticError = {
        provider = 'DiagnosticError',
        icon = ' ' .. s.errorShape .. ' ',
        highlight = 'StatusLineRed',
      }
    },
    {
      DiagnosticWarn = {
        provider = 'DiagnosticWarn',
        icon = '  ' .. s.warningShape .. ' ',
        highlight = 'StatusLineYellow',
      }
    },
    {
      DiagnosticInfo = {
        provider = 'DiagnosticInfo',
        icon = '  ' .. s.infoShape .. ' ',
        highlight = 'StatusLine',
      }
    },
    {
      DiagnosticHint = {
        provider = 'DiagnosticHint',
        icon = '  ' .. s.questionShape .. ' ',
        highlight = 'StatusLine',
      }
    },
    {
      LineInfo = {
        provider = 'LineColumn',
        separator = ' ' .. s.sepRoundLeft,
        icon = ' ',
        separator_highlight = 'StatusLineGreen',
        highlight = 'StatusLineGreenSection',
      }
    },
    {
      PerCent = {
        provider = 'LinePercent',
        separator = ' ',
        separator_highlight = 'StatusLineGreenSection',
        highlight = 'StatusLineGreenSection',
      }
    },
    {
      ScrollBar = {
        provider = 'ScrollBar',
        highlight = 'StatusLineGreenSection',
      }
    },
  }

  gls.short_line_left = {
    {
      ShortFileIcon = {
        provider = { 'FileIcon', 'FileName' },
        -- condition = condition.buffer_not_empty,
        highlight = 'StatusLine',
      }
    },
  }

end

return M
