local M = {}

local ok, theme = pcall(require, "theme.current")
if not ok then -- The theme symlink is missing
  theme = require("theme.catppuccin-mocha") -- Default theme
end

--- Get a plugin-related field from the theme table.
---@param plugin_name string The name of the plugin to get the field for.
---@param field_name string The name of the field to get.
---@return any
function M.get_field(plugin_name, field_name) return theme[plugin_name .. "_" .. field_name] end

--- Get the options for a plugin from the theme table.
---@param plugin_name string The name of the plugin to get the options for.
---@return table
function M.get_opts(plugin_name) return M.get_field(plugin_name, "opts") or {} end

--- Get the lazyness of an optional plugin. This is useful to disable optional plugins depending on the theme, as making
--- them lazy instead of actually disabling them will avoid changing the lazy lock file while still keeping the plugin
--- disabled.
---@param plugin_name string The name of the plugin to get the lazyness of.
---@return boolean
function M.get_lazyness(plugin_name)
  local enabled = M.get_field(plugin_name, "enabled") or false -- By default, don't enable optional plugins
  return not enabled
end

--- Get the options for a plugin. This function merges the default options with the theme-specific options.
---@param plugin_name string The name of the plugin to get the options for.
---@param default_opts table The default options for the plugin.
---@return table
function M.make_opts(plugin_name, default_opts)
  local theme_opts = M.get_opts(plugin_name)
  return vim.tbl_deep_extend("force", default_opts, theme_opts)
end

return M
