local utils = require("utils")

local modules = require("plugins.ui.lualine.modules")
local sections = require("plugins.ui.lualine.sections")

local M = {}

M.tokyonight_enabled = true

M.lualine_opts = {
  options = {
    theme = "tokyonight",
    component_separators = "",
    section_separators = "",
    refresh = {
      statusline = 50, -- Decrease refresh rate to make modules more responsive (e.g. Harpoon's)
    },
  },
  sections = utils.table.concat_dicts({
    sections.empty,
    {
      lualine_c = {
        {
          "filename",
          path = 1, -- Relative path
        },
        "diff",
        "diagnostics",
      },
      lualine_x = utils.table.concat_arrays({
        { modules.macro, modules.harpoon },
        { "location", "progress" },
      }),
    },
  }),
  extensions = {
    -- Redefine some extensions to customize them (see lualine/extensions/ for the initial
    -- implementations)
    {
      sections = utils.table.concat_dicts({
        sections.empty,
        { lualine_c = modules.oil },
      }),
      filetypes = { "oil" },
    },
    {
      sections = utils.table.concat_dicts({
        sections.empty,
        { lualine_c = modules.trouble },
      }),
      filetypes = { "Trouble" },
    },
    {
      sections = utils.table.concat_dicts({
        sections.empty,
        { lualine_c = modules.toggleterm },
      }),
      filetypes = { "toggleterm" },
    },
  },
}

return M
