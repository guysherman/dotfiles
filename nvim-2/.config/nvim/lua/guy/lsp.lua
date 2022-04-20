local lsp_install = require("nvim-lsp-installer")
local diagnosticls = require("diagnosticls-configs")
local lspconfig = require("lspconfig")
local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

local root_dir = lspconfig.util.root_pattern('.git', 'package.json', '.gitignore', 'pom.xml', 'go.mod')
local desired_servers = {
  "gopls",
  "jdtls",
  "tsserver",
  "bashls",
  "vimls",
  "diagnosticls",
  "sumneko_lua",
  "html",
  "cssls",
  "jsonls",
  "terraformls",
  "yamlls",
  "pyright",
  "ccls"
}

local missing_servers = {}
local installed_servers = {}

for _, server in pairs(lsp_install.get_installed_servers()) do
  installed_servers[server.name] = server
end

for _, server_name in pairs(desired_servers) do
  if installed_servers[server_name] == nil then
    table.insert(missing_servers, server_name)
  end
end

if #missing_servers > 0 then
  print("Installing missing servers")
  --lsp_install.install_sync(missing_servers)
  for _, server in pairs(missing_servers) do
    lsp_install.install(server)
  end
else
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  -- nvim-cmp - copied liberally from @Theprimeagen
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local source_mapping = {
    buffer = "[Buffer]",
    nvim_lsp = "[LSP]",
    nvim_lua = "[Lua]",
    path = "[Path]",
  }

  cmp.setup({
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = {
      ["<C-u>"] = cmp.mapping.scroll_docs(-4),
      ["<C-d>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<CR>"] = cmp.mapping.confirm({ select = true })
    },

    formatting = {
      format = function(entry, vim_item)
        vim_item.kind = lspkind.presets.default[vim_item.kind]
        local menu = source_mapping[entry.source.name]
        vim_item.menu = menu
        return vim_item
      end,
    },

    sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "path" },
      { name = "nvim_lua" }
    },
  })

  -- General LSP stuff
  local lsps_path = vim.fn.stdpath("data") .. "/lsp_servers"
  local sumneko_root_path = lsps_path .. "/sumneko_lua/extension/server"
  local sumneko_binary = sumneko_root_path .. "/bin/lua-language-server"

  local opts = { noremap = true, silent = true }
  local function config(_config)
    return vim.tbl_deep_extend("force", {
      capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
      on_attach = function(client, bufnr)
        -- Set custom stuff for some lanugage servers
        if client.name == "tsserver" then
          -- In this case we don't want tsserver to do formatting, because diagnosticls does it
          client.resolved_capabilities.document_formatting = false
        end
        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>iI', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '[g', ':lua vim.diagnostic.goto_next()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', ']g', ':lua vim.diagnostic.goto_prev()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
      end,
      root_dir = root_dir
    }, _config or {})
  end

  local function with_defaults(language_server, defaults)
    return vim.tbl_deep_extend("force", installed_servers[language_server]._default_options, defaults or {})
  end

  -- Languages

  -- lua, thanks @theprimeagen, makes it handle the neovim lua stuff
  require("lspconfig").sumneko_lua.setup(config({
    cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
          -- Setup your lua path
          path = vim.split(package.path, ";"),
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
          },
        },
      },
    },
  }))

  -- gopls
  require("lspconfig").gopls.setup(config(with_defaults("gopls")))

  -- bashls
  require("lspconfig").bashls.setup(config(with_defaults("bashls")))

  -- vimls
  require("lspconfig").vimls.setup(config(with_defaults("vimls")))

  -- jdtls
  require("lspconfig").jdtls.setup(config(with_defaults("jdtls")))

  -- tsserver
  require("lspconfig").tsserver.setup(config(with_defaults("tsserver")))

  -- html
  require("lspconfig").html.setup(config(with_defaults("html")))

  -- css
  require("lspconfig").cssls.setup(config(with_defaults("cssls")))

  -- josn
  require("lspconfig").jsonls.setup(config(with_defaults("jsonls")))

  -- terraform
  require("lspconfig").terraformls.setup(config(with_defaults("terraformls")))

  -- yaml
  require("lspconfig").yamlls.setup(config(with_defaults("yamlls")))

  -- python
  require("lspconfig").pyright.setup(config(with_defaults("pyright")))

  -- c++
  require("lspconfig").ccls.setup(config(with_defaults("ccls")))



  -- diagnosticls
  diagnosticls.init(config(with_defaults("diagnosticls")))
  local eslint = require("diagnosticls-configs.linters.eslint")
  local prettier = require("diagnosticls-configs.formatters.prettier")
  diagnosticls.setup({
    ['javascript'] = {
      linter = eslint,
      formatter = prettier,
    },
    ['javascriptreact'] = {
      linter = eslint,
      formatter = prettier,
    },
    ['typescript'] = {
      linter = eslint,
      formatter = prettier,
    },
    ['typescriptreact'] = {
      linter = eslint,
      formatter = prettier,
    },
  })

end
