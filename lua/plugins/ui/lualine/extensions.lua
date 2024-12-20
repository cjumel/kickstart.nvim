local lualine_modules = require("plugins.ui.lualine.modules")

local M = {}

--- Build dynamically the extensions for the Lualine, depending on the provided sections.
---@param sections table The sections to use for the extensions.
---@return table
function M.build_extensions(sections)
  return {
    -- Custom plugin extensions
    {
      filetypes = { "oil" },
      sections = vim.tbl_deep_extend("force", sections, { lualine_c = lualine_modules.oil }),
    },
    {
      filetypes = { "toggleterm" },
      sections = vim.tbl_deep_extend("force", sections, { lualine_c = lualine_modules.toggleterm }),
    },
    -- Use an empty `lualine_c` section for remaining plugin temporary filetypes, as filetype is still visible
    {
      filetypes = {
        "aerial",
        "copilot-chat",
        "dap-repl",
        "dapui_breakpoints",
        "dapui_console",
        "dapui_scopes",
        "dapui_watches",
        "harpoon",
        "lazy",
        "lspinfo",
        "mason",
        "NeogitCommitPopup",
        "NeogitCommitView",
        "NeogitPopup",
        "NeogitRebasePopup",
        "NeogitResetPopup",
        "NeogitStatus",
        "TelescopePrompt",
        "trouble",
        "undotree",
      },
      sections = vim.tbl_deep_extend("force", sections, { lualine_c = lualine_modules.empty }),
    },
  }
end

return M
