local M = {}

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function M.setup(opts)
  map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  map('n', '<leader>iI', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  map('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  map('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  map('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  map('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  map('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  map('n', ']g', ':lua vim.diagnostic.goto_next()<CR>', opts)
  map('n', '[g', ':lua vim.diagnostic.goto_prev()<CR>', opts)
  map('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

return M
