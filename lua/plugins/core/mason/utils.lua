-- Utilities to handle Mason packages

local M = {}

--- Send a notification with a format specific to `mason.nvim`. This is adapted from `mason-lspconfig.notify`.
---@param msg string The message to display.
---@param level number|nil The log level to use.
---@return nil
local function notify(msg, level)
  level = level or vim.log.levels.INFO
  vim.notify(msg, level, { title = "mason.nvim" })
end

--- Ensure that the given packages are installed with Mason. This is adapted from `mason-lspconfig.ensure_installed` and
--- https://github.com/williamboman/mason.nvim/issues/1309#issuecomment-1555018732.
---@param packages table<string> A list of package names to ensure are installed.
---@return nil
function M.ensure_installed(packages)
  local registry = require("mason-registry")
  registry.refresh(function()
    for _, pkg_name in ipairs(packages) do
      local pkg = registry.get_package(pkg_name)
      if not pkg:is_installed() then
        notify(('Installing "%s"'):format(pkg_name))
        pkg:install()
        notify(('"%s" was successfully installed'):format(pkg_name))
      end
    end
  end)
end

return M
