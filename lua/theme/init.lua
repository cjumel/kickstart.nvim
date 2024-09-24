local M = {}

local ok, theme = pcall(require, "theme.current")
if not ok then -- The theme symlink is missing
  theme = require("theme.default") -- Default theme
end

--- Get a plugin-related field from the theme table. This function simply makes more convenient the access to a plugin
--- option within the theme table, it doesn't do anything really.
---@param plugin_name string The name of the plugin to get the field for.
---@param field_name string The name of the field to get.
---@param default_value any The default value to return, in case the value found is nil.
---@return any _ The value of the relevant field for the given plugin.
function M.get_field(plugin_name, field_name, default_value)
  return theme[plugin_name .. "_" .. field_name] or default_value
end

--- Combine together a plugin's options from the theme table with its default options.
---@param plugin_name string The name of the plugin to make the options for.
---@param default_opts table The default options for the plugin.
---@return table _ The combined options for the plugin.
function M.make_opts(plugin_name, default_opts)
  local theme_opts = M.get_field(plugin_name, "opts", {})
  return vim.tbl_deep_extend("force", default_opts, theme_opts)
end

return M
