local utils = require("utils")

local modules = require("plugins.ui.lualine.modules")
local sections = require("plugins.ui.lualine.sections")

local M = {}

M.rose_pine_enabled = true
M.rose_pine_opts = {
  variant = "main", -- auto, main, moon, or dawn
}

M.lualine_opts = {
  options = {
    icons_enabled = false,
    theme = "auto",
    component_separators = "|",
    section_separators = "",
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
