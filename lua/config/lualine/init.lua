local M = {}

M.custom_modules = require("config.lualine.custom_modules")
M.preset_sections = require("config.lualine.preset_sections")

--- Build dynamically the extensions for the Lualine, depending on the provided sections.
---@param sections table The sections to use for the extensions.
---@return table
M.build_extensions = function(sections)
  return {
    {
      filetypes = { "oil" },
      sections = vim.tbl_deep_extend("force", sections, { lualine_c = M.custom_modules.oil }),
    },
    {
      filetypes = {
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
        "neotest-output-panel",
        "neotest-summary",
        "OverseerList",
        "snacks_dashboard",
        "snacks_picker_input",
        "trouble",
      },
      sections = vim.tbl_deep_extend("force", sections, { lualine_c = M.custom_modules.empty }),
    },
  }
end

return M
