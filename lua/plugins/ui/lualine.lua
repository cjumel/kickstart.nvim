-- lualine.nvim
--
-- A blazing fast and customizable status bar written in Lua.

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
      },
    },
    extensions = {
      "lazy",
      "mason",
      "nvim-dap-ui",
      "oil",
      "overseer",
      "trouble",
    },
  },
}
