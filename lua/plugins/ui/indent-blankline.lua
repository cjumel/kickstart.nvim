-- Indent blankline
--
-- Plugin adding indentation guides in Neovim buffers. This is a super simple yet useful plugin, which I find improves
-- code look and readability.

return {
  "lukas-reineke/indent-blankline.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  main = "ibl",
  event = { "BufNewFile", "BufReadPre" },
  opts = {
    scope = {
      show_end = false, -- Don't underline the end of a scope
      exclude = { language = { "yaml" } }, -- Exclude some languages were the scope works poorly
    },
  },
}
