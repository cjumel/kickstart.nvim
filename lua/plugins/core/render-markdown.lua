return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = "markdown",
  opts = {
    heading = { sign = false }, -- Turn off sign column symbols
    code = { sign = false }, -- Turn off sign column symbols
    checkbox = {
      -- The white spaces at the beginning of rendered icons is useful to prevent the icons from moving horizontally
      -- between raw and rendered modes
      unchecked = { icon = "   󰄱 " },
      checked = { icon = "   󰱒 " },
      custom = {
        todo = { raw = "[-]", rendered = "   󰦖 ", highlight = "RenderMarkdownWarn" }, -- Overwrite the default "todo"
        blocked = { raw = "[o]", rendered = "    ", highlight = "RenderMarkdownWarn" },
        canceled = { raw = "[/]", rendered = "    ", highlight = "RenderMarkdownError" },
      },
    },
  },
}
