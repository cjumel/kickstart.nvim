-- [[ Mason ]]

vim.api.nvim_create_user_command("MasonInstallAll", function()
  require("lazy").load({
    plugins = { -- Ensure `vim.g.mason_ensure_installed` is populated
      "conform.nvim",
      "nvim-dap-python",
      "nvim-lint",
      "nvim-lspconfig",
    },
  })
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
end, { desc = "Install all the missing packages with Mason" })

-- [[ Format-on-save ]]

vim.api.nvim_create_user_command("FormatOnSaveEnable", function(args)
  if args.bang then
    vim.b.disable_format_on_save = false
    vim.notify("Format-on-save enabled for current buffer", vim.log.levels.INFO, { title = "Format-on-save" })
  else
    vim.g.disable_format_on_save = false
    vim.notify("Format-on-save enabled", vim.log.levels.INFO, { title = "Format-on-save" })
  end
end, { desc = "Enable format-on-save", bang = true })

vim.api.nvim_create_user_command("FormatOnSaveDisable", function(args)
  if args.bang then
    vim.b.disable_format_on_save = true
    vim.notify("Format-on-save disabled for current buffer", vim.log.levels.INFO, { title = "Format-on-save" })
  else
    vim.g.disable_format_on_save = true
    vim.notify("Format-on-save disabled", vim.log.levels.INFO, { title = "Format-on-save" })
  end
end, { desc = "Disable format-on-save", bang = true })

vim.api.nvim_create_user_command("FormatOnSaveToggle", function(args)
  if args.bang then
    vim.b.disable_format_on_save = not vim.b.disable_format_on_save
    local status = vim.b.disable_format_on_save and "disabled" or "enabled"
    vim.notify("Format-on-save " .. status .. " for current buffer", vim.log.levels.INFO, { title = "Format-on-save" })
  else
    vim.g.disable_format_on_save = not vim.g.disable_format_on_save
    local status = vim.g.disable_format_on_save and "disabled" or "enabled"
    vim.notify("Format-on-save " .. status, vim.log.levels.INFO, { title = "Format-on-save" })
  end
end, { desc = "Toggle format_on_save", bang = true })

-- [[ Lint ]]

vim.api.nvim_create_user_command("LintEnable", function(args)
  if args.bang then
    vim.b.disable_lint = false
    vim.notify("Lint enabled for current buffer", vim.log.levels.INFO, { title = "Lint" })
  else
    vim.g.disable_lint = false
    vim.notify("Lint enabled", vim.log.levels.INFO, { title = "Lint" })
  end
end, { desc = "Enable lint", bang = true })
vim.api.nvim_create_user_command("LintDisable", function(args)
  if args.bang then
    vim.b.disable_lint = true
    vim.notify("Lint disabled for current buffer", vim.log.levels.INFO, { title = "Lint" })
  else
    vim.g.disable_lint = true
    vim.notify("Lint disabled", vim.log.levels.INFO, { title = "Lint" })
  end
  vim.diagnostic.reset() -- Discard existing diagnotics
end, { desc = "Disable lint", bang = true })
vim.api.nvim_create_user_command("LintToggle", function(args)
  if args.bang then
    vim.b.disable_lint = not vim.b.disable_lint
    local status = vim.b.disable_lint and "disabled" or "enabled"
    vim.notify("Lint " .. status .. " for current buffer", vim.log.levels.INFO, { title = "Lint" })
  else
    vim.g.disable_lint = not vim.g.disable_lint
    local status = vim.g.disable_lint and "disabled" or "enabled"
    vim.notify("Lint " .. status, vim.log.levels.INFO, { title = "Lint" })
  end
  vim.diagnostic.reset() -- Discard existing diagnotics
end, { desc = "Toggle lint", bang = true })
