-- lualine.nvim
--
-- A blazing fast and easy to configure neovim statusline plugin written in pure lua.

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  priority = 100, -- Main UI stuff should be loaded first
  opts = function()
    local opts = {
      options = {
        component_separators = "",
        section_separators = "",
        globalstatus = true, -- Better single global status line for all splits
      },
      sections = {
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
        lualine_x = {
          { -- Display macro recording status when there is one
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
            color = { fg = "#ff9e64" }, -- Orange
          },
          {
            "searchcount",
            color = { fg = "#ff9e64" }, -- Orange
          },
          {
            function()
              if vim.g.last_task_status == "success" then
                return ""
              elseif vim.g.last_task_status == "failure" then
                return ""
              elseif vim.g.last_task_status == "in progress" then
                return ""
              end
            end,
            cond = function() return vim.g.last_task_status ~= nil end,
            color = function()
              if vim.g.last_task_status == "success" then
                return { fg = "#98c379" } -- Green
              elseif vim.g.last_task_status == "failure" then
                return { fg = "#e06c75" } -- Red
              elseif vim.g.last_task_status == "in progress" then
                return { fg = "#61afef" } -- Blue
              end
            end,
          },
          "filetype",
        },
        lualine_y = { "location" },
        lualine_z = { "progress" },
      },
      tabline = { lualine_y = { "tabs" } },
    }
    if ThemeConfig.get_lualine_opts ~= nil then
      opts = vim.tbl_deep_extend("force", opts, ThemeConfig.get_lualine_opts(opts) or {})
    end
    opts.extensions = {
      {
        filetypes = { "oil" },
        sections = vim.tbl_deep_extend("force", opts.sections, {
          lualine_c = {
            function()
              local oil = package.loaded.oil
              if oil ~= nil then
                local path = oil.get_current_dir()
                return vim.fn.fnamemodify(path, ":p:~:.")
              end
            end,
          },
        }),
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
        sections = vim.tbl_deep_extend("force", opts.sections, { lualine_c = { function() return "" end } }),
      },
    }
    return opts
  end,
  config = function(_, opts)
    local lualine = require("lualine")
    lualine.setup(opts)
    if ThemeConfig.lualine_callback then -- Additional theme options setting
      ThemeConfig.lualine_callback()
    end
  end,
}
