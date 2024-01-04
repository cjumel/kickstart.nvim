-- Indent blankline
--
-- Add indentation guides even on blank lines.

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufNewFile", "BufReadPre" },
  keys = {
    {
      "<leader>,s",
      function()
        vim.cmd("IBLToggleScope")
      end,
      desc = "Settings: toggle [S]cope highlighting",
    },
  },
  opts = {},
}
