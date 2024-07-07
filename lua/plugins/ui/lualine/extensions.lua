local modules = require("plugins.ui.lualine.modules")

local M = {}

--- Build dynamically the extensions for the Lualine, depending on the provided sections.
---@param sections table The sections to use for the extensions.
---@return table
function M.build_extensions(sections)
  return {
    {
      sections = vim.tbl_deep_extend("force", sections, { lualine_c = modules.harpoon_buffer_title }),
      filetypes = { "harpoon" },
    },
    {
      sections = vim.tbl_deep_extend("force", sections, { lualine_c = modules.oil }),
      filetypes = { "oil" },
    },
    {
      sections = vim.tbl_deep_extend("force", sections, { lualine_c = modules.toggleterm }),
      filetypes = { "toggleterm" },
    },
  }
end

return M
