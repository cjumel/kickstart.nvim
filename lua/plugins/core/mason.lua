return {
  "mason-org/mason.nvim",
  cmd = { "Mason", "MasonInstallAll", "MasonUninstallAll" },
  opts = {},
  config = function(_, opts)
    require("mason").setup(opts)

    vim.api.nvim_create_user_command("MasonInstallAll", function()
      local ensure_installed = {}
      for _, pkg_name in ipairs(vim.g.mason_ensure_installed or {}) do
        if not vim.tbl_contains(ensure_installed, pkg_name) then
          table.insert(ensure_installed, pkg_name)
        end
      end
      local mason_registry = require("mason-registry")
      mason_registry.refresh(function()
        local no_package_to_install = true
        for _, pkg_name in ipairs(ensure_installed) do
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
