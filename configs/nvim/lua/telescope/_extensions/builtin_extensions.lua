-- TODO: Document
local builtin = require('telescope.builtin')
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local conf = require('telescope.config').values
local pickers = require('telescope.pickers')

local function new_job (command_generator, entry_maker, maximum_results, cwd)
  return finders._new {
    fn_command = function(_, prompt)
      local command_list = command_generator(prompt)
      if command_list == nil then
        return nil
      end

      local command = table.remove(command_list, 1)

      return {
        command = command,
        args = command_list,
      }
    end,
    cwd = cwd,
    entry_maker = entry_maker,
    maximum_results = maximum_results,
  }
end

local function live_grep (opts)
  local live_grepper = new_job(function(prompt)

      if not prompt or prompt == "" then
        return nil
      end

      return vim.tbl_flatten { conf.vimgrep_arguments, prompt }
    end,
    opts.entry_maker or make_entry.gen_from_vimgrep(opts),
    opts.maxinum_results,
    opts.cwd
  )

  pickers.new(opts, {
    prompt_title = 'Live Grep',
    finder = live_grepper,
    previewer = conf.grep_previewer(opts),
    sorter = conf.generic_sorter(opts),
  }):find()
end

local function get_workspace_folder ()
  return vim.lsp.buf.list_workspace_folders()[1] or vim.fn.systemlist('git rev-parse --show-toplevel')[1]
end

local function live_grep_workspace (opts)
  opts.cwd = get_workspace_folder()
  live_grep(opts)
end

local function find_files_workspace (opts)
  opts.cwd = get_workspace_folder()
  builtin.find_files(opts)
end

local function grep_string_workspace (opts)
  opts.cwd = get_workspace_folder()
  builtin.grep_string(opts)
end

return require('telescope').register_extension {
  setup = function()
    builtin.my_live_grep = live_grep
    builtin.live_grep_workspace = live_grep_workspace
    builtin.find_files_workspace = find_files_workspace
    builtin.grep_string_workspace = grep_string_workspace
  end;
}
