-- lualine.nvim
--
-- A blazing fast and customizable status bar written in Lua.

local utils = require("utils")

-- Handle the case the theme file is missing
local ok, theme = pcall(require, "theme")
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
  opts = utils.table.concat_dicts({
    {
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = "|",
        section_separators = "",
        refresh = {
          statusline = 50, -- Decrease refresh rate to make modules more responsive (e.g. Harpoon's)
        },
      },
      sections = utils.table.concat_dicts({
        sections.default,
        {
          lualine_x = utils.table.concat_arrays({
            {
              modules.macro,
              modules.harpoon,
            },
            sections.default.lualine_x,
          }),
        },
      }),
      extensions = {
        -- Redefine some extensions to customize them (see lualine/extensions/ for the initial
        -- implementations)
        {
          sections = utils.table.concat_dicts({
            sections.default,
            { lualine_c = modules.oil },
          }),
          filetypes = { "oil" },
        },
        {
          sections = utils.table.concat_dicts({
            sections.default,
            { lualine_c = modules.trouble },
          }),
          filetypes = { "Trouble" },
        },
        {
          sections = utils.table.concat_dicts({
            sections.default,
            { lualine_c = modules.toggleterm },
          }),
          filetypes = { "toggleterm" },
        },
      },
    },
    theme.lualine_opts or {},
  }),
}
