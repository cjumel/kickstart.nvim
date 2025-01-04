-- Tokyo Night
--
-- Clean, dark and light Neovim themes written in Lua and ported from the Visual Studio Code TokyoNight theme. This
-- plugin comes with many features and integrations, like LSP or Treesitter support. The Tokyo Night theme is also
-- available for many tools other than Neovim, making it one of the most popular color schemes out there.

return {
  "folke/tokyonight.nvim",
  cond = require("theme").tokyonight_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  opts = vim.tbl_deep_extend("force", {
    style = "night", -- "night", "moon", "storm" or "day"
    transparent = true,
  }, require("theme").tokyonight_opts or {}),
  config = function(_, opts)
    local tokyonight = require("tokyonight")

    tokyonight.setup(opts) -- Setup must be called before loading the color scheme
    vim.cmd.colorscheme("tokyonight")
  end,
}
