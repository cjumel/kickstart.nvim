-- Module directly adapted from mason-lspconfig.notify

local notify = require("plugins.core.mason.notify")

--- Ensure that the given packages are installed with Mason. This is adapted from:
--- https://github.com/williamboman/mason.nvim/issues/1309#issuecomment-1555018732
---@param packages table<string>
---@return nil
local function ensure_installed(packages)
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

return ensure_installed
