-- lualine.nvim
--
-- A blazing fast and customizable status bar plugin for Neovim written in Lua. lualine.nvim has integrations with many
-- popular plugins and can be further customized manually while remaining quite simple, making it a great choice for any
-- configuration.

local extensions = require("plugins.ui.lualine.extensions")
local sections = require("plugins.ui.lualine.sections")

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  priority = 100, -- Main UI stuff should be loaded first
  opts = vim.tbl_deep_extend("force", {
    options = {
      component_separators = "",
      section_separators = "",
      disabled_filetypes = { "snacks_dashboard" },
      globalstatus = true, -- Use a single global status line for all splits (precedes `vim.o.laststatus`)
    },
    sections = sections.default,
    extensions = extensions.build_extensions(sections.default),
  }, Theme.lualine_opts or {}),
  config = function(_, opts)
    require("lualine").setup(opts)
    if Theme.lualine_callback then -- Additional theme options setting
      Theme.lualine_callback()
    end
  end,
}
