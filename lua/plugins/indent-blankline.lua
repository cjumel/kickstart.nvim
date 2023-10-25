-- Indent blankline
--
-- Add indentation guides even on blank lines.

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufNewFile", "BufReadPre" },
  opts = {
    scope = {
      enabled = false,
    },
  },
}
