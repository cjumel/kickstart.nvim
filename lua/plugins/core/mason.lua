-- mason.nvim
--
-- Portable package manager for Neovim that runs everywhere Neovim runs. Easily install and manage LSP servers, DAP
-- servers, linters, and formatters.

return {
  "mason-org/mason.nvim",
  cmd = { "Mason", "MasonInstallAll", "MasonUninstallAll" },
  opts = {},
  config = function(_, opts)
    require("mason").setup(opts)

    -- Command to ensure that the given packages are installed. Sources:
    -- - mason-lspconfig.ensure_installed
    -- - https://github.com/mason-org/mason.nvim/issues/1309#issuecomment-1555018732.
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
