local util = require 'lspconfig.util'

local env = {
  HOME = vim.loop.os_homedir(),
  JAVA_HOME = os.getenv 'JAVA_HOME',
  JDTLS_HOME = os.getenv 'JDTLS_HOME',
  WORKSPACE = os.getenv 'WORKSPACE',
  PLATFORM = vim.loop.os_uname().sysname,
}

local function get_workspace_name()
  local cwd = vim.fn.getcwd(0)
  local _, workplace_end = string.find(cwd, "workplace/guysnz/" )
  if workplace_end == nil then
    _, workplace_end = string.find(cwd, "workplace/")
  end
  if workplace_end == nil then
    return "default"
  end

  local workplace_relative_path = string.sub(cwd, workplace_end+1)
  local workspace_end, _ = string.find(workplace_relative_path, "/")
  local workspace_name = string.sub(workplace_relative_path, 0, workspace_end-1)

  return workspace_name
end

local function get_workspace_dir()
  local workspace_dir = util.path.join(env.HOME, 'workspace')
  return util.path.join(workspace_dir, get_workspace_name())
end

local function get_cellar_path()
  if env.PLATFORM == "Darwin" then
    return '/usr/local/Cellar'
  else
    return '/home/linuxbrew/.linuxbrew/Cellar'
  end
end

local function get_jdtls_config()
  if env.PLATFORM == "Darwin" then
    return 'libexec/config_mac'
  else
    return 'libexec/config_linux'
  end
end



local root_dir = require('jdtls.setup').find_root({ 'packageInfo', '.mvnroot' }, 'Config')

local ws_folders_lsp = {}
local ws_folders_jdtls = {}
if root_dir then
  local file = io.open(root_dir .. "/.bemol/ws_root_folders", "r");
  if file then
    for line in file:lines() do
      table.insert(ws_folders_lsp, line);
      table.insert(ws_folders_jdtls, string.format("file://%s", line))
    end
    file:close()
  end
end

local lombokPath = util.path.join(env.HOME, '.local/bin/lombok.jar')
local javaxAnnotationApiPath = util.path.join(env.HOME, '.local/bin/javx.annotation-api-1.3.2.jar')
local javaAgent = '-javaagent:' .. lombokPath
local lombokBootclassPath = '-Xbootclasspath/a:' .. lombokPath
local javaxAnnotationBootClassPath = '-Xbootclasspath/a:' .. javaxAnnotationApiPath
local jdtlsPath = util.path.join(get_cellar_path(), 'jdtls/1.18.0')
local jdtlsJarPath = util.path.join(jdtlsPath, 'libexec/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar')
local jdtlsConfigPath = util.path.join(jdtlsPath, get_jdtls_config())


-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    -- 💀
    'java', -- or '/path/to/java11_or_newer/bin/java'
    -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '-Xmx2G',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    javaAgent,
    --lombokBootclassPath,
    --javaxAnnotationBootClassPath,

    -- 💀
    '-jar', jdtlsJarPath,
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
    -- Must point to the                                                     Change this to
    -- eclipse.jdt.ls installation                                           the actual version


    -- 💀
    '-configuration', jdtlsConfigPath,
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
    -- Must point to the                      Change to one of `linux`, `win` or `mac`
    -- eclipse.jdt.ls installation            Depending on your system.


    -- 💀
    -- See `data directory configuration` section in the README
    '-data', get_workspace_dir()
  },

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = root_dir,

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      format = {
        settings = {
          url = "~/.config/aws-ip-viola.xml",
          profile = "aws-ip-viola",

        }
      }
    }
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {},
    workspaceFolders = ws_folders_jdtls
  },
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)

for _, line in ipairs(ws_folders_lsp) do
  vim.lsp.buf.add_workspace_folder(line)
end

local opts = { noremap = true, silent = true }
local bufnr = 0
--vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
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
vim.api.nvim_buf_set_keymap(bufnr, 'n', ']g', ':lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', '[g', ':lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
