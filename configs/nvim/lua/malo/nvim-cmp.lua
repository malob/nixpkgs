-- nvim-cmp
-- A completion plugin for neovim coded in Lua.
-- https://github.com/hrsh7th/nvim-cmp

local cmp = require 'cmp'

-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

cmp.setup {
  sources = {
    { name = 'async_path' },
    { name = 'buffer' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
  },

  -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings
  mapping = {
    ['<C-Space>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },

    ['<Tab>'] = function(fallback)
      if not cmp.select_next_item() then
        if vim.bo.buftype ~= 'prompt' and has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    end,

    ['<S-Tab>'] = function(fallback)
      if not cmp.select_prev_item() then
        if vim.bo.buftype ~= 'prompt' and has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    end,
  },
}
