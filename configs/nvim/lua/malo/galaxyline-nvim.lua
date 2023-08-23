local utils = require 'malo.utils'
local const = utils.const
local s = utils.symbols

-- galaxyline.nvim (fork)
-- https://github.com/NTBBloodbath/galaxyline.nvim
vim.cmd 'packadd galaxyline.nvim'

local gl = require 'galaxyline'
local condition = require 'galaxyline.condition'

gl.short_line_list = { 'floaterm' }

gl.section.left = {
  {
    Mode = {
      provider = function()
        local alias = {
          c = s.term,
          i = s.pencil,
          n = s.vim,
          R = '',
          t = s.term,
          v = s.ibar,
          V = s.ibar,
          [''] = s.ibar,
        }
        return '  ' .. alias[vim.fn.mode()] .. ' '
      end,
      highlight = 'StatusLineMode',
      separator = s.sepRoundRight .. ' ',
      separator_highlight = 'StatusLineModeSep',
    }
  },
  {
    FileIcon = {
      condition = condition.buffer_not_empty,
      provider = function ()
        vim.cmd('hi GalaxyFileIcon guifg='..require'galaxyline.providers.fileinfo'.get_file_icon_color()..' guibg='..require'lush_theme.malo'.StatusLine.bg.hex)
        return require'galaxyline.providers.fileinfo'.get_file_icon() .. ' '
      end,
      highlight = {},
    }
  },
  {
    FileName = {
      condition = condition.buffer_not_empty,
      provider = 'FileName',
      highlight = 'StatusLineFileName',
    }
  },
  {
    GitBranch = {
      condition = condition.buffer_not_empty,
      icon = '  ' .. s.gitBranch .. ' ',
      provider = 'GitBranch',
      highlight = 'StatusLineGitBranch',
    }
  },
  {
    DiffAdd = {
      condition = condition.hide_in_width,
      icon = ' ',
      provider = 'DiffAdd',
      highlight = 'StatusLineDiffAdd',
    }
  },
  {
    DiffModified = {
      condition = condition.hide_in_width,
      icon = ' ',
      provider = 'DiffModified',
      highlight = 'StatusLineDiffModified',
    }
  },
  {
    DiffRemove = {
      condition = condition.hide_in_width,
      icon = ' ',
      provider = 'DiffRemove',
      highlight = 'StatusLineDiffRemove',
    }
  },
}

gl.section.right = {
  {
    LspClient = {
      condition = condition.check_active_lsp,
      provider = { 'GetLspClient', const(' ') },
      highlight = 'StatusLineLspClient',
    }
  },
  {
    DiagnosticError = {
      condition = condition.check_active_lsp,
      icon = ' ' .. s.errorShape .. ' ',
      provider = 'DiagnosticError',
      highlight = 'StatusLineDiagnosticError',
    }
  },
  {
    DiagnosticWarn = {
      condition = condition.check_active_lsp,
      icon = '  ' .. s.warningShape .. ' ',
      provider = 'DiagnosticWarn',
      highlight = 'StatusLineDiagnosticWarn',
    }
  },
  {
    DiagnosticInfo = {
      condition = condition.check_active_lsp,
      icon = '  ' .. s.infoShape .. ' ',
      provider = 'DiagnosticInfo',
      highlight = 'StatusLineDiagnosticInfo',
    }
  },
  {
    DiagnosticHint = {
      condition = condition.check_active_lsp,
      icon = '  ' .. s.questionShape .. ' ',
      provider = 'DiagnosticHint',
      highlight = 'StatusLineDiagnosticHint',
    }
  },
  {
    LineInfo = {
      separator = ' ' .. s.sepRoundLeft,
      separator_highlight = 'StatusLineModeSep',
      icon = ' ',
      provider = 'LineColumn',
      highlight = 'StatusLineLineInfo',
    }
  },
  {
    FilePosition = {
      separator = ' ',
      separator_highlight = 'StatusLineFilePositionSep',
      provider = { 'LinePercent', 'ScrollBar' },
      highlight = 'StatusLineFilePosition',
    }
  },
}

gl.section.short_line_left = {
  {
    ShortStatusLine = {
      condition = condition.buffer_not_empty,
      provider = { const('  '), 'FileIcon', const(' '), 'FileName' },
      highlight = 'StatusLineSortStatusLine',
    }
  },
}
