-- lualine.nvim
--
-- A blazing fast and customizable status bar written in Lua.

local ok, theme = pcall(require, "theme") -- Handle the case the theme file is missing
if not ok then
  theme = {}
end

local modules = require("plugins.ui.lualine.modules")
local sections = require("plugins.ui.lualine.sections")

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  priority = 100, -- Main UI stuff should be loaded first
  opts = vim.tbl_deep_extend("force", {
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = "|",
      section_separators = "",
      refresh = {
        statusline = 50, -- Decrease refresh rate to make modules more responsive (e.g. Harpoon's)
      },
    },
    sections = vim.tbl_deep_extend("force", sections.default, {
      lualine_x = vim.list_extend({
        modules.macro,
        modules.harpoon,
      }, sections.default.lualine_x),
    }),
    extensions = {
      -- Redefine some extensions to customize them (see lualine/extensions/ for the initial implementations)
      {
        sections = vim.tbl_deep_extend("force", sections.default, {
          lualine_c = modules.oil,
          lualine_x = vim.list_extend({
            modules.harpoon,
            modules.fake_encoding, -- Add a fake encoding for consistency with regular buffers
          }, sections.default.lualine_x),
        }),
        filetypes = { "oil" },
      },
      {
        sections = vim.tbl_deep_extend("force", sections.default, { lualine_c = modules.trouble }),
        filetypes = { "Trouble" },
      },
      {
        sections = vim.tbl_deep_extend("force", sections.default, { lualine_c = modules.toggleterm }),
        filetypes = { "toggleterm" },
      },
    },
  }, theme.lualine_opts or {}),
}
