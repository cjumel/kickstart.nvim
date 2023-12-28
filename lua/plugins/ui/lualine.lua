-- lualine.nvim
--
-- A blazing fast and customizable status bar written in Lua.

-- Redefine some extensions to customize them (see lualine/extensions/ for the initial
-- implementations)

local custom_extensions = {
  oil = {
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = {
        function()
          local ok, oil = pcall(require, "oil")
          if ok then
            return vim.fn.fnamemodify(oil.get_current_dir(), ":~")
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
}

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "folke/noice.nvim",
  },
  priority = 100, -- Main UI stuff should be loaded first
  opts = {
    options = {
      theme = "catppuccin",
      component_separators = "|",
      section_separators = "",
    },
    -- Add a message in the status line when recording a macro
    -- This means that noice needs to pass the message to the statusline (see noice's wiki)
    sections = {
      lualine_x = {
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
      "nvim-dap-ui",
      custom_extensions.oil,
      "overseer",
      "trouble",
    },
  },
}
