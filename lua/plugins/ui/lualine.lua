-- lualine.nvim
--
-- A blazing fast and customizable status bar written in Lua.

-- Redefine some extensions to customize them (see lualine/extensions/ for the initial
-- implementations)

local custom_extensions = {
  generic = {
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_x = { "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    filetypes = {
      -- DAP
      "dap-repl",
      "dapui_console",
      "dapui_watches",
      "dapui_stacks",
      "dapui_breakpoints",
      "dapui_scopes",
      -- DB-UI
      "dbui",
      -- Neogit
      "NeogitStatus",
      "NeogitPopup",
      "NeogitCommitMessage",
      -- Noice
      "noice",
      -- Overseer
      "OverseerList",
      -- Undo-tree
      "undotree",
    },
  },
  oil = {
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = {
        function()
          local ok, oil = pcall(require, "oil")
          if ok then
            -- Show relative path if in directory, or truncate with "~" if possible
            return vim.fn.fnamemodify(oil.get_current_dir(), ":p:~:.")
          else
            return ""
          end
        end,
      },
      lualine_x = { "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    filetypes = { "oil" },
  },
  trouble = {
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = {
        function()
          local opts = require("trouble.config").options
          local words = vim.split(opts.mode, "[%W]")
          for i, word in ipairs(words) do
            words[i] = word:sub(1, 1):upper() .. word:sub(2)
          end
          return table.concat(words, " ")
        end,
      },
      lualine_x = { "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    filetypes = { "Trouble" },
  },
}

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  priority = 100, -- Main UI stuff should be loaded first
  opts = {
    options = {
      theme = "catppuccin",
      component_separators = "|",
      section_separators = "",
    },
    sections = {
      lualine_c = {
        {
          "filename",
          path = 1, -- Relative path
          symbols = {
            modified = "●", -- Text to show when the buffer is modified
          },
        },
      },
      lualine_x = {
        -- Add a message in the status line when recording a macro
        -- This means that noice needs to pass the message to the statusline (see noice's wiki)
        {
          function()
            return require("noice").api.statusline.mode.get()
          end,
          cond = function()
            return require("noice").api.statusline.mode.has()
          end,
          color = { fg = "#ff9e64" },
        },
        -- Default content
        "encoding",
        "fileformat",
        "filetype",
      },
    },
    extensions = {
      custom_extensions.generic,
      custom_extensions.oil,
      custom_extensions.trouble,
    },
  },
}
