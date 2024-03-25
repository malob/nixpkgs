-- noice.nvim
-- Replaces the UI for messages, cmdline and the popupmenu
-- https://github.com/folke/noice.nvim

require 'noice'.setup {
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },

    -- Signature help is handled by `nvim-cmp`
    signature = {
      auto_open = { enable = false },
    },
  },

  presets = {
    command_palette = true,
    long_message_to_split = true,
    -- lsp_doc_border = true,
  },

}
