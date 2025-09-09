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
          "harpoon",
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
          "neotest-output",
          "neotest-summary",
          "OverseerList",
          "snacks_dashboard",
          "snacks_notif_history",
          "snacks_picker_input",
          "trouble",
        },
        sections = vim.tbl_deep_extend("force", opts.sections, { lualine_c = { function() return "" end } }),
      },
    }
    return opts
  end,
}
