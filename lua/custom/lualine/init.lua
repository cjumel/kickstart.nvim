-- Module to not show anything in a status line component
local empty_module = { function() return "" end }

-- Module to display a message in a status line component when recording a macro
-- Source: https://github.com/folke/noice.nvim/wiki/Configuration-Recipes#show-recording-messages
local macro_module = {
  function()
    local noice = package.loaded.noice
    if noice ~= nil then
      return noice.api.statusline.mode.get()
    end
  end,
  cond = function()
    local noice = package.loaded.noice
    if noice ~= nil then
      return noice.api.statusline.mode.has()
    end
  end,
  color = { fg = "#ff9e64" },
}

-- Module to show the path of the directory opened with Oil (instead of Oil's buffer path) in a status line component
local oil_dir_module = {
  function()
    local oil = package.loaded.oil
    return vim.fn.fnamemodify(oil.get_current_dir(), ":p:~:.")
  end,
}

local M = {}

--- Build dynamically Lualine extensions, depending on the provided sections and using the custom modules.
---@param sections table The sections to use for the extensions.
---@return table
function M.build_extensions(sections)
  return {
    {
      filetypes = { "oil" },
      sections = vim.tbl_deep_extend("force", sections, { lualine_c = oil_dir_module }),
    },
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
        "snacks_dashboard",
        "snacks_picker_input",
        "TelescopePrompt",
        "trouble",
        "undotree",
      },
      sections = vim.tbl_deep_extend("force", sections, { lualine_c = empty_module }),
    },
  }
end

M.preset_sections = {
  default = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = {
      {
        "filename",
        path = 1, -- Relative path
        symbols = { modified = "●" }, -- Text to show when the buffer is modified
      },
      "diff",
      "diagnostics",
    },
    lualine_x = { macro_module, "filetype" },
    lualine_y = { "location" },
    lualine_z = { "progress" },
  },
  minimalist = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      { "filename", path = 1 }, -- Relative file path
      "diff",
      "diagnostics",
    },
    lualine_x = { macro_module, "filetype", "location", "progress" },
    lualine_y = {},
    lualine_z = {},
  },
}

return M
