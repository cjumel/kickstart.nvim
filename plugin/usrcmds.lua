-- [[ Diagnostics ]]

vim.api.nvim_create_user_command("DiagnosticsEnable", function(args)
  local message, filter = "Diagnostics enabled", {}
  if args.bang then
    filter.bufnr = 0
    message = message .. " for current buffer"
  end
  vim.diagnostic.enable(true, filter)
  vim.notify(message, vim.log.levels.INFO, { title = "Diagnostics" })
end, { desc = "Enable diagnostics", bang = true })
vim.api.nvim_create_user_command("DiagnosticsDisable", function(args)
  local message, filter = "Diagnostics disabled", {}
  if args.bang then
    filter.bufnr = 0
    message = message .. " for current buffer"
  end
  vim.diagnostic.enable(false, filter)
  vim.notify(message, vim.log.levels.INFO, { title = "Diagnostics" })
end, { desc = "Disable diagnotics", bang = true })
vim.api.nvim_create_user_command("DiagnosticsToggle", function(args)
  local message, filter = "", {}
  if args.bang then
    filter.bufnr = 0
    message = " for current buffer"
  end
  local is_enabled = vim.diagnostic.is_enabled(filter)
  message = "Diagnostics " .. (is_enabled and "disabled" or "enabled") .. message
  vim.diagnostic.enable(not is_enabled, filter)
  vim.notify(message, vim.log.levels.INFO, { title = "Diagnostics" })
end, { desc = "Toggle diagnostics", bang = true })

-- [[ Mason ]]

vim.api.nvim_create_user_command("InstallAll", function(args)
  -- Load plugins which require installing a binary
  require("lazy").load({ plugins = { "blink.cmp", "codediff.nvim", "copilot.lua" } })

  local mason_package_versions =
    vim.tbl_deep_extend("force", require("config.data").mason_package_versions, vim.g.mason_package_versions or {})
  local mason_registry = require("mason-registry")
  mason_registry.refresh(function()
    local no_package_to_install = true
    for name, version in pairs(mason_package_versions) do
      local pkg = mason_registry.get_package(name)
      if args.bang or not pkg:is_installed() then
        vim.notify(('Installing "%s@%s"...'):format(name, version), vim.log.levels.INFO, { title = "mason.nvim" })
        pkg:install({ version = version })
        no_package_to_install = false
      end
    end
    if no_package_to_install then
      vim.notify("No packages to install", vim.log.levels.INFO, { title = "mason.nvim" })
    end
  end)
end, { desc = "Install all required Nvim artefacts", bang = true })

-- [[ Format-on-save ]]

vim.api.nvim_create_user_command("FormatOnSaveEnable", function(args)
  if args.bang then
    vim.b.format_on_save_is_disabled = false
    vim.notify("Format-on-save enabled for current buffer", vim.log.levels.INFO, { title = "Format-on-save" })
  else
    vim.g.format_on_save_is_disabled = false
    vim.notify("Format-on-save enabled", vim.log.levels.INFO, { title = "Format-on-save" })
  end
end, { desc = "Enable format-on-save", bang = true })
vim.api.nvim_create_user_command("FormatOnSaveDisable", function(args)
  if args.bang then
    vim.b.format_on_save_is_disabled = true
    vim.notify("Format-on-save disabled for current buffer", vim.log.levels.INFO, { title = "Format-on-save" })
  else
    vim.g.format_on_save_is_disabled = true
    vim.notify("Format-on-save disabled", vim.log.levels.INFO, { title = "Format-on-save" })
  end
end, { desc = "Disable format-on-save", bang = true })
vim.api.nvim_create_user_command("FormatOnSaveToggle", function(args)
  if args.bang then
    vim.b.format_on_save_is_disabled = not vim.b.format_on_save_is_disabled
    local status = vim.b.format_on_save_is_disabled and "disabled" or "enabled"
    vim.notify("Format-on-save " .. status .. " for current buffer", vim.log.levels.INFO, { title = "Format-on-save" })
  else
    vim.g.format_on_save_is_disabled = not vim.g.format_on_save_is_disabled
    local status = vim.g.format_on_save_is_disabled and "disabled" or "enabled"
    vim.notify("Format-on-save " .. status, vim.log.levels.INFO, { title = "Format-on-save" })
  end
end, { desc = "Toggle format-on-save", bang = true })

-- [[ Neovim configuration ]]

vim.api.nvim_create_user_command("NvimConfigLocalInit", function()
  local config_file = vim.fn.getcwd() .. "/.nvim.lua"
  if vim.fn.filereadable(config_file) == 1 then
    error("Local Neovim config file already exists")
  end
  local example_file = vim.fn.stdpath("config") .. "/.nvim-example.lua"
  local example_content = vim.fn.readfile(example_file)
  vim.fn.writefile(example_content, config_file)
  vim.cmd.edit(config_file)
end, { desc = "Initialize the local Neovim config file" })
vim.api.nvim_create_user_command("NvimConfigLocalEdit", function()
  local config_file = vim.fn.getcwd() .. "/.nvim.lua"
  vim.cmd.edit(config_file)
end, { desc = "Edit the local Neovim config file" })
vim.api.nvim_create_user_command("NvimConfigLocalYankExample", function()
  local example_file = vim.fn.stdpath("config") .. "/.nvim-example.lua"
  local example_content = vim.fn.readfile(example_file)
  vim.fn.setreg('"', table.concat(example_content, "\n"))
  vim.notify('Local Neovim config example yanked to register `"`', vim.log.levels.INFO, { title = "Neovim config" })
end, { desc = "Yank the local Neovim config example" })

vim.api.nvim_create_user_command("NvimConfigGlobalInit", function()
  local config_file = vim.fn.stdpath("config") .. "/.nvim-global.lua"
  if vim.fn.filereadable(config_file) == 1 then
    error("Global Neovim config file already exists")
  end
  local example_file = vim.fn.stdpath("config") .. "/.nvim-global-example.lua"
  local example_content = vim.fn.readfile(example_file)
  vim.fn.writefile(example_content, config_file)
  vim.cmd.edit(config_file)
end, { desc = "Initialize the global Neovim config file" })
vim.api.nvim_create_user_command("NvimConfigGlobalEdit", function()
  local config_file = vim.fn.stdpath("config") .. "/.nvim-global.lua"
  vim.cmd.edit(config_file)
end, { desc = "Edit the global Neovim config file" })
vim.api.nvim_create_user_command("NvimConfigGlobalYankExample", function()
  local example_file = vim.fn.stdpath("config") .. "/.nvim-global-example.lua"
  local example_content = vim.fn.readfile(example_file)
  vim.fn.setreg('"', table.concat(example_content, "\n"))
  vim.notify('Global config example yanked to register `"`', vim.log.levels.INFO, { title = "Neovim config" })
end, { desc = "Yank the global Neovim config example" })
