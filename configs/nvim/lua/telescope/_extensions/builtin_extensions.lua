local builtin = require('telescope.builtin')

local function get_workspace_folder ()
  return vim.lsp.buf.list_workspace_folders()[1] or vim.fn.systemlist('git rev-parse --show-toplevel')[1]
end

return require('telescope').register_extension {
  setup = function()

    builtin.live_grep_workspace = function(opts)
      opts.cwd = get_workspace_folder()
      builtin.live_grep(opts)
    end

    builtin.find_files_workspace = function(opts)
      opts.cwd = get_workspace_folder()
      builtin.find_files(opts)
    end

    builtin.grep_string_workspace = function(opts)
      opts.cwd = get_workspace_folder()
      builtin.grep_string(opts)
    end

  end;
}
