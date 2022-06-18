require('guy.treesitter')
require('refactoring').setup({})

-- prompt for a refactor to apply when the remap is triggered
vim.api.nvim_set_keymap(
  "v",
  "<leader>rr",
  ":lua require('refactoring').select_refactor()<CR>",
  { noremap = true, silent = true, expr = false }
)
