-- nvim-lspconfig
-- Configure available LSPs
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
--
-- Note that all languag e servers aside from `sumneko_lua` are installed via Nix. See:
-- `../../../../home/neovim.nix`.
vim.cmd 'packadd nvim-lspconfig'

local lspconf = require 'lspconfig'

lspconf.bashls.setup {}
lspconf.ccls.setup {}
lspconf.hls.setup {}
lspconf.jsonls.setup {}
lspconf.rnix.setup {}
lspconf.sourcekit.setup {}

-- Fix for `nvim-lspconfig` no longer handling installing language servers
local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
end
local sumneko_root_path = vim.fn.stdpath('cache')..'/lspconfig/sumneko_lua/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"
lspconf.sumneko_lua.setup {
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      intelliSense = {
        searchDepth = 10
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.env.VIMRUNTIME .. '/lua'] = true,
          [vim.env.VIMRUNTIME .. '/lua/vim/lsp'] = true,
        },
        maxPreload = 2000,
        preloadFileSize = 1000,
      },
    },
  },
}

lspconf.tsserver.setup {}

lspconf.vimls.setup {
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
}

lspconf.yamlls.setup {
  settings = {
    yaml = {
      format = {
        printWidth = 100,
        singleQuote = true,
      },
    },
  },
}