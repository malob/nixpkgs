-- Highlights used with statusline defined in `../../statusline.lua`.
local t = require'lush_theme.malo'

---@diagnostic disable: undefined-global
return require'lush'(function()
  return {
    StatusLineMode    { t.GreenBg, fg = t.LightBaseFg.fg },
    StatusLineModeSep { t.StatusLine, fg = t.GreenFg.fg },

    StatusLineFileName { t.StatusLine, gui = 'italic' },

    StatusLineGitBranch    { t.StatusLine, gui = 'bold' },
    StatusLineDiffAdd      { t.StatusLine, fg = t.AddText.fg },
    StatusLineDiffModified { t.StatusLine, fg = t.ChangeText.fg },
    StatusLineDiffRemove   { t.StatusLine, fg = t.DeleteText.fg },

    StatusLineLspClient       { t.StatusLine },
    StatusLineDiagnosticError { t.StatusLine, fg = t.ErrorText.fg },
    StatusLineDiagnosticWarn  { t.StatusLine, fg = t.WarningText.fg },
    StatusLineDiagnosticInfo  { t.StatusLine },
    StatusLineDiagnosticHint  { StatusLineDiagnosticInfo },

    StatusLineLineInfo        { StatusLineMode },
    StatusLineLineInfoSep     { StatusLineModeSep },
    StatusLineFilePosition    { StatusLineMode },
    StatusLineFilePositionSep { StatusLineMode },

    StatusLineSortStatusLine { t.StatusLineNC },
  }
end)

