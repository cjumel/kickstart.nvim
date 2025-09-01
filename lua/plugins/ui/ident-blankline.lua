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
