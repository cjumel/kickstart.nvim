-- render-markdown.nvim
--
-- render-markdown.nvim improves viewing Markdown files. In comparison to other approaches, this pluggin doesn't provide
-- an actual rendering of the Markdown file, but I don't find such feature necessary, and a bit cumbersome to use.
-- Instead, render-markdown.nvim simply improves the way Markdown files are displayed directly in Neovim buffers.

return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = "markdown",
  opts = {
    heading = { sign = false }, -- Turn off symbols in the sign column for headings
    checkbox = {
      -- The white spaces at the beginning of rendered icons is useful to prevent the icons from moving horizontally
      -- between raw and rendered modes
      unchecked = { icon = "   󰄱 " },
      checked = { icon = "   󰱒 " },
      custom = {
        wip = { raw = "[-]", rendered = "   󰥔 ", highlight = "RenderMarkdownWarn" },
        canceled = { raw = "[/]", rendered = "    ", highlight = "RenderMarkdownError" },
      },
    },
  },
}
