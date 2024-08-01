-- markdown.nvim
--
-- markdown.nvim improves viewing Markdown files. In comparison to other approaches, this pluggin doesn't provide an
-- actual rendering of the Markdown file, but I don't find such feature necessary, and a bit cumbersome to use. Instead,
-- markdown.nvim simply improves the way Markdown files are displayed directly in Neovim buffers.

return {
  "MeanderingProgrammer/markdown.nvim",
  main = "render-markdown",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = "markdown",
  opts = {
    heading = {
      sign = false, -- Turn off symbols in the sign column for headings
    },
  },
}
