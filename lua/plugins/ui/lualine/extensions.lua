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
    --  See `vim.g.temporary_filetypes` in `plugin/filetypes.lua` for the full list of temporary filetypes
    {
      filetypes = {
        "", -- No buffer opened
        "copilot-chat",
        "dap-repl",
        "dapui_breakpoints",
        "dapui_console",
        "dapui_scopes",
        "dapui_watches",
        "gitcommit",
        "harpoon",
        "lazy",
        "lspinfo",
        "mason",
        "NeogitCommitMessage",
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
      sections = vim.tbl_deep_extend("force", sections, { lualine_c = modules.empty }),
    },
  }
end

return M
