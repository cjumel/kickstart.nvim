-- Headlines.nvim
--
-- Add highlights for headlines, codes blocks, quotes, etc.

local utils = require("utils")

return {
  "lukas-reineke/headlines.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "markdown" },
  opts = utils.theme.make_opts("headlines", {
    markdown = {
      bullets = {}, -- Disable bullets as they don't bring much & make editing headlines harder
    },
  }),
}
