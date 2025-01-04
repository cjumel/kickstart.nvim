local ok, current_theme = pcall(require, "theme.current")
if not ok then -- The theme symlink is missing
  current_theme = require("theme.default")
end

return current_theme
