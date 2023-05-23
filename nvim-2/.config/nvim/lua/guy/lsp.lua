local keymaps = require("guy.lspKeyMaps")
local lsp_install = require("nvim-lsp-installer")
local diagnosticls = require("diagnosticls-configs")
local lspconfig = require("lspconfig")
local configs = require 'lspconfig.configs'
local cmp = require("cmp")
local platformlsp = require('guy.platform-lsp')
--local luasnip = require("luasnip")
local lspkind = require("lspkind")
--local cmp_luasnip = require("cmp_luasnip")

local root_dir = lspconfig.util.root_pattern('.git', 'package.json', '.gitignore', 'pom.xml', 'go.mod')
local desired_servers = {
  "gopls",
  --"jdtls",
  "tsserver",
  "bashls",
  "vimls",
  "diagnosticls",
  "sumneko_lua",
  "html",
  "cssls",
  "jsonls",
  --"terraformls",
  "yamlls",
  "pyright",
  --  "ccls",
  "rust_analyzer",
  "solargraph"
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

-- Check if the config is already defined (useful when reloading this file)
if not configs.barium then
    configs.barium = {
        default_config = {
            cmd = {'barium'};
            filetypes = {'brazil-config'};
            root_dir = function(fname)
                return lspconfig.util.find_git_ancestor(fname)
            end;
            settings = {};
        };
    }
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

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    {border = 'rounded'}
  )

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    {border = 'rounded'}
  )

  vim.diagnostic.config({
    float = {
      border = 'rounded',
    },
  })

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

  require('snippy').setup({
    mappings = {
      is = {
        ['<Tab>'] = 'expand_or_advance',
        ['<S-Tab>'] = 'previous',
      },
      nx = {
        ['<leader>x'] = 'cut_text',
      },
    },
  })

  cmp.setup({
    snippet = {
      expand = function(args)
        require("snippy").expand_snippet(args.body)
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
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<CR>"] = cmp.mapping.confirm({ select = false })
    },

    formatting = {
      format = function(entry, vim_item)
        vim_item.kind = string.format("%s %s", lspkind.presets.default[vim_item.kind], vim_item.kind)
        local menu = source_mapping[entry.source.name]
        vim_item.menu = menu
        return vim_item
      end,
    },

    sources = {
      { name = "nvim_lsp" },
      { name = "snippy" },
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
      capabilities = vim.lsp.protocol.make_client_capabilities(),
      on_attach = function(client, bufnr)
        -- Set custom stuff for some lanugage servers
        if client.name == "tsserver" then
          -- In this case we don't want tsserver to do formatting, because diagnosticls does it
          client.server_capabilities.documentFormattingProvider = false
        end
        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        --vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format { async = true }]]
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
  --require("lspconfig").jdtls.setup(config(with_defaults("jdtls", {
  --settings = {
  --java = {
  --format = {
  --settings = {
  --url = "~/.config/jdtls-format.xml",
  --profile = "GoogleStyle",
  --}
  --}
  --}
  --}
  --})))

  -- tsserver
  require("lspconfig").tsserver.setup(config(with_defaults("tsserver", {
    typescript = {
      preferences = {
        renameShorthandProperties = false,
      }
    }
  })))

  -- html
  require("lspconfig").html.setup(config(with_defaults("html")))

  -- css
  require("lspconfig").cssls.setup(config(with_defaults("cssls")))

  -- josn
  require("lspconfig").jsonls.setup(config(with_defaults("jsonls")))

  -- terraform
  --require("lspconfig").terraformls.setup(config(with_defaults("terraformls")))

  -- yaml
  require("lspconfig").yamlls.setup(config(with_defaults("yamlls")))

  -- python
  require("lspconfig").pyright.setup(config(with_defaults("pyright")))

  -- c++
  require("lspconfig").ccls.setup({})

  -- rust
  require("lspconfig").rust_analyzer.setup(config(with_defaults("rust_analyzer")))

  -- solargraph/ruby
  require("lspconfig").solargraph.setup(config(with_defaults("solargraph")))



  --require("lspconfig").metals.setup({})

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

  --local snippets_paths = function()
    --local plugins = { "friendly-snippets" }
    --local paths = { "$HOME/.config/nvim/snippets" }
    --local path
    --local root_path = vim.fn.stdpath('data') .. "/plugged/"
    --for _, plug in ipairs(plugins) do
      --path = root_path .. plug
      --if vim.fn.isdirectory(path) ~= 0 then
        --table.insert(paths, path)
      --end
    --end
    --return paths
  --end

  --require("luasnip.loaders.from_vscode").lazy_load({
    --paths = snippets_paths(),
    --include = nil, -- Load all languages
    --exclude = {},
  --})
  platformlsp.setup()
  keymaps.setup(opts)
end


