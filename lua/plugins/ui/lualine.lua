-- lualine.nvim
--
-- A blazing fast and easy to configure neovim statusline plugin written in pure lua.

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
      globalstatus = true, -- Better single global status line for all splits
    },
    sections = sections.default,
    extensions = extensions.build_extensions(sections.default),
    tabline = {
      lualine_y = { "tabs" },
    },
  }, Theme.lualine_opts or {}),
  config = function(_, opts)
    require("lualine").setup(opts)
    if Theme.lualine_callback then -- Additional theme options setting
      Theme.lualine_callback()
    end
  end,
}
