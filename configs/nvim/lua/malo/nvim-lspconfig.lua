-- nvim-lspconfig
-- Configure available LSPs
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
--
-- Note that all languag e servers aside from `sumneko_lua` are installed via Nix. See:
-- `../../../../home/neovim.nix`.
local foreach = require 'pl.tablex'.foreach
local augroup = require 'malo.utils'.augroup

local lspconf = require 'lspconfig'

local function on_attach(client, bufnr)
  print(vim.inspect(client.server_capabilities))
  if client.server_capabilities.documentHighlightProvider then
    augroup { name = 'MaloLspDocumentHighlights' .. bufnr, cmds = {
      {{ 'CursorHold', 'CursorHoldI' }, {
        buffer = bufnr,
        desc = "Create LSP document highlights",
        callback = vim.lsp.buf.document_highlight,
      }},
      {{ 'CursorMoved' }, {
        buffer = bufnr,
        desc = "Clear LSP document highlights",
        callback = vim.lsp.buf.clear_references,
      }},
    }}
  end
end

local servers_config = {
  bashls = {},
  ccls = {},
  hls = {},
  jsonls = {},
  pyright = {},
  rnix = {},
  sourcekit = {},

  sumneko_lua = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (LuaJIT in the case of Neovim)
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          maxPreload = 5000,
          preloadFileSize = 1000,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },

  tsserver = {},

  vimls = {
    init_options = {
      iskeyword = '@,48-57,_,192-255,-#',
      vimruntime = vim.env.VIMRUNTIME,
      runtimepath = vim.o.runtimepath,
      diagnostic = {
        enable = true,
      },
      indexes = {
        runtimepath = true,
        gap = 100,
        count = 8,
        projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
      },
      suggest = {
        fromRuntimepath = true,
        fromVimruntime = true
      },
    }
  },

  yamlls = {
    settings = {
      yaml = {
        format = {
          printWidth = 100,
          singleQuote = true,
        },
      },
    },
  },
}

foreach(servers_config, function(v, k)
  lspconf[k].setup(require'coq'.lsp_ensure_capabilities(
   vim.tbl_extend('error', v, { on_attach = on_attach })
  ))
end)

