local M = {}

--- Get the theme module, or fallback to the default theme if the theme module symlink is missing.
---@return table<string, any>
function M.get_theme()
  local ok, theme = pcall(require, "_theme")
  if not ok then -- The theme symlink is missing
    theme = require("themes.catppuccin-mocha")
  end
  return theme
end

--- Get the lazyness of an optional plugin. This is useful to disable optional plugins depending on the theme, as making
--- them lazy instead of actually disabling them will avoid changing the lazy lock file while still keeping the plugin
--- disabled.
---@param plugin_name string The name of the plugin to get the lazyness of.
---@return boolean
function M.get_lazyness(plugin_name)
  local theme = M.get_theme()
  local enabled = theme[plugin_name .. "_enabled"] or false -- By default, don't enable optional plugins
  return not enabled
end

--- Get the options for a plugin. This function merges the default options with the theme-specific options.
---@param plugin_name string The name of the plugin to get the options for.
---@param default_opts table The default options for the plugin.
---@return table
function M.make_opts(plugin_name, default_opts)
  local theme = M.get_theme()
  local theme_opts = theme[plugin_name .. "_opts"] or {}
  return vim.tbl_deep_extend("force", default_opts, theme_opts)
end

return M
