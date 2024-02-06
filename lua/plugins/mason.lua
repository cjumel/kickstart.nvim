-- mason.nvim
--
-- Mason.nvim is a portable package manager for Neovim written in Lua.
-- In this implementation, packages are installed in two ways: packages defined in
-- `ensure_installed` are installed by running `:MasonInstallAll`, and packages defined in
-- the LSP configuration are automatically installed when the LSP server is initialized.

return {
  'williamboman/mason.nvim',
  cmd = {
    'Mason',
    'MasonInstall',
    'MasonInstallAll', -- Custom command to install all Mason packages (taken from NvChad)
    'MasonUninstall',
    'MasonUninstallAll',
    'MasonUpdate',
    'MasonLog',
  },
  opts = {
    ensure_installed = {
      -- Lua
      'stylua',
      -- Python
      'black',
      'ruff',
      'mypy',
      -- Other
      'prettier',
    },
  },
  config = function(_, opts)
    require('mason').setup(opts)

    -- Custom command to install all Mason packages (taken from NvChad)
    vim.api.nvim_create_user_command('MasonInstallAll', function()
      vim.cmd('MasonInstall ' .. table.concat(opts.ensure_installed, ' '))
    end, {})

    vim.g.mason_binaries_list = opts.ensure_installed
  end,
}
