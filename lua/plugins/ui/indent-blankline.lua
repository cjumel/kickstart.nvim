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
      include = { -- Add treesitter nodes considered as scope by indent-blankline
        node_type = {
          ["lua"] = {
            "function_call",
            "table_constructor",
          },
          ["python"] = {
            "call",
            "assignment",
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
