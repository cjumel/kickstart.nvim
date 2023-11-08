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
          -- Get only a message when recording a macro, not other events (e.g. entering insert mode)
          function()
            local mode = require("noice").api.statusline.mode.get()
            if mode then
              return string.match(mode, "^recording @.*") or ""
            end
            return ""
          end,
          color = { fg = "#ff9e64" },
        },
      },
    },
  },
}
