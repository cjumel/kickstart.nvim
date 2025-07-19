local ok, current_theme = pcall(require, "config.theme.current")
if not ok then -- The theme symlink is missing
  current_theme = require("config.theme.default")
end

return current_theme
