-- Indent blankline
--
-- Add indentation guides even on blank lines.

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufNewFile", "BufReadPre" },
  opts = {
    scope = {
      show_end = false, -- Don't underline the end of the scope
      include = {
        node_type = { -- Add treesitter nodes to be considered as scope
          ["python"] = {
            -- By default, only actual variable scopes are considered: classes & functions
            "if_statement",
            "for_statement",
            "while_statement",
            "with_statement",
          },
        },
      },
      exclude = {
        language = {
          "toml", -- Works not great & very few indent levels so not very useful
          "yaml", -- Works very poorly, add more noise than value
        },
      },
    },
  },
}
