vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- empty setup using defaults
require("nvim-tree").setup({
  view = {
    width = 50
  },
  git = {
    ignore = false
  }
})

local options = { noremap = true }
vim.api.nvim_set_keymap('n', '<c-n>n', ':execute \'NvimTreeToggle\' getcwd()<CR>', options)
vim.api.nvim_set_keymap('n', '<c-n>f', ':NvimTreeFindFileToggle<CR>', options)
