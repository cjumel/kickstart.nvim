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
    {
      filetypes = { -- All the remaining temporary filetypes
        "", -- No buffer opened
        "copilot-chat",
        "dap-repl",
        "dapui_breakpoints",
        "dapui_console",
        "dapui_scopes",
        "dapui_watches",
        "harpoon",
        "NeogitCommitPopup",
        "NeogitCommitView",
        "NeogitRebasePopup",
        "NeogitResetPopup",
        "NeogitStatus",
        "TelescopePrompt",
      },
      sections = vim.tbl_deep_extend("force", sections, { lualine_c = modules.empty }),
    },
  }
end

return M
