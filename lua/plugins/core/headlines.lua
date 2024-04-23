-- Headlines.nvim
--
-- Add highlights for headlines, codes blocks, quotes, etc.

local ok, theme = pcall(require, "theme") -- Handle the case the theme file is missing
if not ok then
  theme = {}
end

return {
  "lukas-reineke/headlines.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  ft = { "markdown" },
  opts = vim.tbl_deep_extend("force", {
    markdown = {
      bullets = {}, -- Disable bullets as they don't bring much & make editing headlines harder
    },
  }, theme.headlines_opts or {}),
}
