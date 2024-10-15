-- mason.nvim
--
-- mason.nvim is a portable package manager for Neovim that runs everywhere Neovim runs, to easily install and manage
-- LSP servers, DAP servers, linters, and formatters, for instance. It covers all the tools I need, and thus occupies a
-- central role in my configuration to integrate tools in Neovim.

local nvim_config = require("nvim_config")

return {
  "williamboman/mason.nvim",
  cond = not nvim_config.light_mode,
  cmd = {
    "Mason",
    "MasonUpdate",
    "MasonInstall",
    "MasonInstallAll",
    "MasonUninstall",
    "MasonUninstallAll",
  },
  opts = {
    ui = { border = "rounded" }, -- Add a border in Mason UI to improve visibility in transparent backgrounds
  },
  config = function(_, opts)
    require("mason").setup(opts)

    -- Command to ensure that the given packages are installed. This is adapted from mason-lspconfig.ensure_installed
    --  and https://github.com/williamboman/mason.nvim/issues/1309#issuecomment-1555018732.
    vim.api.nvim_create_user_command("MasonInstallAll", function()
      local mason_registry = require("mason-registry")
      mason_registry.refresh(function()
        local no_package_to_install = true
        for _, pkg_name in ipairs(vim.g.mason_ensure_installed or {}) do
          local pkg = mason_registry.get_package(pkg_name)
          if not pkg:is_installed() then
            vim.notify(('Installing "%s"...'):format(pkg_name), vim.log.levels.INFO, { title = "mason.nvim" })
            pkg:install()
            no_package_to_install = false
          end
        end
        if no_package_to_install then
          vim.notify("No package to install", vim.log.levels.INFO, { title = "mason.nvim" })
        end
      end)
    end, { desc = "Install with Mason all the missing packages" })
  end,
}
