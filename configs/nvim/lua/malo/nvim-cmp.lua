-- nvim-cmp
-- A completion plugin for neovim coded in Lua.
-- https://github.com/hrsh7th/nvim-cmp

local cmp = require 'cmp'

local luasnip = require 'luasnip'
require 'luasnip.loaders.from_vscode'.lazy_load()
require 'luasnip.loaders.from_snipmate'.lazy_load()

require 'copilot_cmp'.setup {}

-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup {
  sources = {
    { name = 'async_path' },
    { name = 'copilot' },
    { name = 'buffer' },
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
  },

  formatting = {
    format = require 'lspkind'.cmp_format {
      mode = 'symbol',
      show_labelDetails = true,
      symbol_map = { Copilot = "" },
    },
  },

  snippet = {
    expand = function(args)
      require 'luasnip'.lsp_expand(args.body)
    end,
  },

  -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
  mapping = {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
}
