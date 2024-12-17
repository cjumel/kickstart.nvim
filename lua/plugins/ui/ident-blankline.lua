-- Indent blankline
--
-- Plugin adding indentation guides in Neovim buffers. This is a super simple yet very useful plugin, which I find
-- improves code look and readability. Besides, it does what it does efficiently and robustly, handling more edge cases
-- than alternatives like snacks.nvim corresponnding feature.

return {
  "lukas-reineke/indent-blankline.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  main = "ibl",
  event = { "BufNewFile", "BufReadPre" },
  opts = {
    scope = {
      show_start = false,
      show_end = false,
      exclude = { language = { "yaml" } }, -- Exclude languages were the scope feature works poorly
    },
    exclude = { filetypes = { "markdown", "text" } }, -- Exclude non-code filetypes
  },
}
