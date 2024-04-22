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
    refresh = {
      statusline = 50, -- Decrease refresh rate to make modules more responsive (e.g. Harpoon's)
    },
  },
  sections = vim.tbl_deep_extend("force", sections.empty, {
    lualine_c = {
      {
        "filename",
        path = 1, -- Relative path
      },
      "diff",
      "diagnostics",
    },
    lualine_x = vim.list_extend({ modules.macro, modules.harpoon }, { "location", "progress" }),
  }),
  extensions = {
    -- Redefine some extensions to customize them (see lualine/extensions/ for the initial implementations)
    {
      sections = vim.tbl_deep_extend("force", sections.empty, {
        lualine_c = modules.oil,
        lualine_x = vim.list_extend({ modules.harpoon }, { "location", "progress" }),
      }),
      filetypes = { "oil" },
    },
    {
      sections = vim.tbl_deep_extend("force", sections.empty, { lualine_c = modules.trouble }),
      filetypes = { "Trouble" },
    },
    {
      sections = vim.tbl_deep_extend("force", sections.empty, { lualine_c = modules.toggleterm }),
      filetypes = { "toggleterm" },
    },
  },
}

return M
