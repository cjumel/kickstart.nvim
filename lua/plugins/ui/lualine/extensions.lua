local modules = require("plugins.ui.lualine.modules")

local M = {}

--- Build dynamically the extensions for the Lualine, depending on the provided sections.
---@param sections table The sections to use for the extensions.
---@return table
function M.build_extensions(sections)
  return {
    -- Custom plugin extensions
    {
      filetypes = { "oil" },
      sections = vim.tbl_deep_extend("force", sections, { lualine_c = modules.oil }),
    },
    {
      filetypes = { "toggleterm" },
      sections = vim.tbl_deep_extend("force", sections, { lualine_c = modules.toggleterm }),
    },
    -- Use an empty `lualine_c` section for remaining plugin temporary filetypes, as filetype is still visible
    {
      filetypes = {
        "aerial",
        "checkhealth",
        "copilot-chat",
        "dap-repl",
        "dapui_breakpoints",
        "dapui_console",
        "dapui_scopes",
        "dapui_watches",
        "lazy",
        "lspinfo",
        "mason",
        "NeogitCommitPopup",
        "NeogitCommitView",
        "NeogitConsole",
        "NeogitPopup",
        "NeogitRebasePopup",
        "NeogitResetPopup",
        "NeogitStatus",
        "OverseerList",
        "snacks_dashboard",
        "snacks_picker_input",
        "trouble",
        "undotree",
      },
      sections = vim.tbl_deep_extend("force", sections, { lualine_c = modules.empty }),
    },
  }
end

return M
