local modules = require("plugins.ui.lualine.modules")

local M = {}

--- Copy the provided section & replace the "encoding" module with a fake one.
---@param section table The section to replace the "encoding" module in.
---@return table
local function replace_with_fake_encoding(section)
  local ret = {}
  for _, module in ipairs(section) do
    if module == "encoding" then
      table.insert(ret, modules.fake_encoding)
    else
      table.insert(ret, module)
    end
  end
  return ret
end

--- Build dynamically the extensions for the Lualine, depending on the provided sections.
---@param sections table The sections to use for the extensions.
---@return table
function M.build_extensions(sections)
  return {
    {
      sections = vim.tbl_deep_extend("force", sections, {
        lualine_c = modules.oil,
        lualine_x = replace_with_fake_encoding(sections.lualine_x),
      }),
      filetypes = { "oil" },
    },
    {
      sections = vim.tbl_deep_extend("force", sections, { lualine_c = modules.toggleterm }),
      filetypes = { "toggleterm" },
    },
    {
      sections = vim.tbl_deep_extend("force", sections, { lualine_c = modules.trouble }),
      filetypes = { "Trouble" },
    },
  }
end

return M
