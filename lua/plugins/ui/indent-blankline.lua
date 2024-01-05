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
  opts = {
    scope = {
      show_end = false, -- Don't underline the end of the scope
      -- Add treesitter nodes to be considered as scope by indent-blankline
      -- To not overload this feature, only add nodes which contains actual code as they can be
      -- arbitrary long & complex
      include = {
        node_type = {
          ["*"] = {
            "if_statement",
            "for_statement",
            "while_statement",
            "with_statement",
          },
        },
      },
    },
  },
}
