-- Auto Pairs
--
-- Automatically insert brackets in pairs.

return {
  "windwp/nvim-autopairs",
  event = { "BufNewFile", "BufReadPre" },
  opts = {},
}
