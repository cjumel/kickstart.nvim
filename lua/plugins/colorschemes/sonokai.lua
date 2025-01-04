-- sonokai
--
-- Neovim color scheme plugin providing high contrast and vivid color scheme based on Monokai Pro.

return {
  "sainnhe/sonokai",
  cond = require("theme").sonokai_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  config = function()
    vim.g.sonokai_transparent_background = true
    vim.cmd.colorscheme("sonokai")
  end,
}
