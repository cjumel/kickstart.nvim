-- Headlines.nvim
--
-- Add highlights for headlines, codes blocks, quotes, etc.

local theme = require("theme")

return {
  "lukas-reineke/headlines.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "markdown" },
  opts = theme.make_opts("headlines", {
    markdown = {
      bullets = {}, -- Disable bullets as they don't bring much & make editing headlines harder
    },
  }),
}
