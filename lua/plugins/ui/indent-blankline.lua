-- Indent blankline
--
-- Plugin adding indentation guides in Neovim buffers. This is a super simple yet useful plugin, which I find improves
-- code look and readability.

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufNewFile", "BufReadPre" },
  opts = {
    scope = {
      show_end = false, -- Don't underline the end of a scope
      include = {
        node_type = { -- Add treesitter nodes to be considered as scope
          ["python"] = {
            -- By default, only actual variable scopes are considered (classes & functions), let's add more
            "if_statement",
            "for_statement",
            "while_statement",
            "with_statement",
          },
        },
      },
      exclude = {
        language = {
          "toml", -- Works not great & very few indent levels so not very useful all in all
          "yaml", -- Works very poorly, add more noise than value
        },
      },
    },
  },
}
