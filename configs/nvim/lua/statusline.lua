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
        condition = condition.buffer_not_empty,
        provider = function ()
          vim.cmd('hi GalaxyFileIcon guifg='..require'galaxyline.provider_fileinfo'.get_file_icon_color()..' guibg='..c.basehl)
          return require'galaxyline.provider_fileinfo'.get_file_icon() .. ' '
        end,
        highlight = {},
      }
    },
    {
      FileName = {
        condition = condition.buffer_not_empty,
        provider = 'FileName',
        highlight = 'StatusLineItalic',
      }
    },
    {
      GitBranch = {
        condition = condition.buffer_not_empty,
        icon = '  ' .. s.gitBranch .. ' ',
        provider = 'GitBranch',
        highlight = 'StatusLineBold',
      }
    },
    {
      DiffAdd = {
        condition = condition.hide_in_width,
        icon = ' ',
        provider = 'DiffAdd',
        highlight = 'StatusLineGreen',
      }
    },
    {
      DiffModified = {
        condition = condition.hide_in_width,
        icon = ' ',
        provider = 'DiffModified',
        highlight = 'StatusLineYellow',
      }
    },
    {
      DiffRemove = {
        condition = condition.hide_in_width,
        icon = ' ',
        provider = 'DiffRemove',
        highlight = 'StatusLineRed',
      }
    },
  }

  gls.right = {
    {
      LspClient = {
        condition = condition.check_active_lsp,
        provider = { 'GetLspClient', _.constant(' ') },
        highlight = 'StatusLine',
      }
    },
    {
      DiagnosticError = {
        condition = condition.check_active_lsp,
        icon = ' ' .. s.errorShape .. ' ',
        provider = 'DiagnosticError',
        highlight = 'StatusLineRed',
      }
    },
    {
      DiagnosticWarn = {
        condition = condition.check_active_lsp,
        icon = '  ' .. s.warningShape .. ' ',
        provider = 'DiagnosticWarn',
        highlight = 'StatusLineYellow',
      }
    },
    {
      DiagnosticInfo = {
        condition = condition.check_active_lsp,
        icon = '  ' .. s.infoShape .. ' ',
        provider = 'DiagnosticInfo',
        highlight = 'StatusLine',
      }
    },
    {
      DiagnosticHint = {
        condition = condition.check_active_lsp,
        icon = '  ' .. s.questionShape .. ' ',
        provider = 'DiagnosticHint',
        highlight = 'StatusLine',
      }
    },
    {
      LineInfo = {
        separator = ' ' .. s.sepRoundLeft,
        separator_highlight = 'StatusLineGreen',
        icon = ' ',
        provider = 'LineColumn',
        highlight = 'StatusLineGreenSection',
      }
    },
    {
      Position = {
        separator = ' ',
        separator_highlight = 'StatusLineGreenSection',
        provider = { 'LinePercent', 'ScrollBar' },
        highlight = 'StatusLineGreenSection',
      }
    },
  }

  gls.short_line_left = {
    {
      ShortFileIcon = {
        provider = { _.constant('  '), 'FileIcon', _.constant(' '), 'FileName' },
        highlight = 'StatusLine',
      }
    },
  }

end

return M
