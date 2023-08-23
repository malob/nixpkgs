-- no-neck-pain.nvim
-- Center the currently focused buffer to the middle of the screen
-- https://github.com/shortcuts/no-neck-pain.nvim

require'no-neck-pain'.setup {
  width = 107,
  autocmds = {
    enableOnVimEnter = true,
    reloadOnColorSchemeChange = true,
  },
}
