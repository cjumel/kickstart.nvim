local filetypes = require("filetypes")
local modules = require("plugins.ui.lualine.modules")

local M = {}

--- Build dynamically the extensions for the Lualine, depending on the provided sections.
---@param sections table The sections to use for the extensions.
---@return table
function M.build_extensions(sections)
  return {
    {
      filetypes = { "oil" },
      sections = vim.tbl_deep_extend("force", sections, { lualine_c = modules.oil }),
    },
    {
      filetypes = { "toggleterm" },
      sections = vim.tbl_deep_extend("force", sections, { lualine_c = modules.toggleterm }),
    },
    -- Use an empty `lualine_c` section for all the remaining temporary filetypes
    {
      filetypes = vim.tbl_filter(
        function(value) return not vim.tbl_contains({ "oil", "toggleterm" }, value) end,
        filetypes.temporary_filetypes
      ),
      sections = vim.tbl_deep_extend("force", sections, { lualine_c = modules.empty }),
    },
  }
end

return M
