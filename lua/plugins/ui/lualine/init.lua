-- lualine.nvim
--
-- A blazing fast and customizable status bar written in Lua.

local extensions = require("plugins.ui.lualine.extensions")
local sections = require("plugins.ui.lualine.sections")
local theme = require("theme")

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  priority = 100, -- Main UI stuff should be loaded first
  opts = theme.make_opts("lualine", {
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = "|",
      section_separators = "",
      globalstatus = true, -- Use a single global status line for all splits (precedes `vim.o.laststatus`)
      refresh = { statusline = 50 }, -- Decrease refresh rate to make modules more responsive (e.g. Harpoon's)
    },
    sections = sections.default,
    extensions = extensions.build_extensions(sections.default),
  }),
  config = function(_, opts)
    require("lualine").setup(opts)

    -- Status line global options
    vim.opt.showmode = false -- Don't show mode in status line as it is redundant with Lualine's onw feature
  end,
}
