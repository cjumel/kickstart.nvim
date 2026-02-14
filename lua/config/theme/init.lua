local ok, current_theme = pcall(require, "config.theme.current")
if not ok then
  current_theme = require("config.theme.default")
end

---@type ThemeConfig
return current_theme
