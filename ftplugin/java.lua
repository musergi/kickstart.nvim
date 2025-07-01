local home = os.getenv 'HOME'
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace = home .. '/.cache/jdtls/workspace' .. project_name
local share_dir = vim.fn.stdpath 'data'
local path_to_mason_packages = share_dir .. '/mason/packages'
local path_to_jdtls = path_to_mason_packages .. '/jdtls'
local path_to_jdebug = path_to_mason_packages .. '/java-debug-adapter'
local path_to_jtest = path_to_mason_packages .. '/java-test'
local path_to_config = path_to_jdtls .. '/config_linux'
local lombok_path = path_to_jdtls .. '/lombok.jar'
local path_to_jar = path_to_jdtls .. '/plugins/org.eclipse.equinox.launcher_1.7.0.v20250331-1702.jar'
local bundles = {
  vim.fn.glob(path_to_jdebug .. '/extension/server/com.microsoft.java.debug.plugin-*.jar', true),
}
vim.list_extend(bundles, vim.split(vim.fn.glob(path_to_jtest .. '/extension/server/*.jar', true), '\n'))

local config = {
  cmd = {
    'java',

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '-javaagent:' .. lombok_path,
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',

    '-jar',
    path_to_jar,
    '-configuration',
    path_to_config,
    '-data',
    workspace,
  },

  root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew' }),

  settings = {
    java = {},
  },

  init_options = {
    bundles = bundles,
  },
}

require('jdtls').start_or_attach(config)
