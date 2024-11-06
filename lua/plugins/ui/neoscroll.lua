-- Neoscroll
--
-- Neoscroll is a smooth scrolling Neovim plugin written in Lua. It makes scrolling in Neovim far easier on the eyes,
-- as one can follow a line of text while scrolling, whereas the default scrolling behavior makes the text disappear
-- and reappear at another place, making it super hard to follow in my opinion.

return {
  "karb94/neoscroll.nvim",
  keys = function()
    local actions = require("plugins.ui.neoscroll.actions")
    return {
      { "<C-u>", actions.c_u, mode = { "n", "v", "x" }, desc = "Scroll half a page up" },
      { "<C-d>", actions.c_d, mode = { "n", "v", "x" }, desc = "Scroll half a page down" },
      { "<C-b>", actions.c_b, mode = { "n", "v", "x" }, desc = "Scroll a page up" },
      { "<C-f>", actions.c_f, mode = { "n", "v", "x" }, desc = "Scroll a page down" },

      { "<C-y>", actions.c_y, mode = { "n", "v", "x" }, desc = "Scroll a few lines up" },
      { "<C-e>", actions.c_e, mode = { "n", "v", "x" }, desc = "Scroll a few lines down" },

      { "zt", actions.zt, mode = { "n", "v", "x" }, desc = "Top this line" },
      { "zz", actions.zz, mode = { "n", "v", "x" }, desc = "Center this line" },
      { "zb", actions.zb, mode = { "n", "v", "x" }, desc = "Bottom this line" },

      -- Map arrow keys to navigate within a document with only one hand on the keyboard
      { "<Up>", actions.c_y, mode = { "n", "v", "x" }, desc = "Scroll a few lines up" },
      { "<Down>", actions.c_e, mode = { "n", "v", "x" }, desc = "Scroll a few lines down" },
      { "<Left>", actions.c_u, mode = { "n", "v", "x" }, desc = "Scroll half a page up" },
      { "<Right>", actions.c_d, mode = { "n", "v", "x" }, desc = "Scroll half a page down" },
    }
  end,
  opts = {
    mappings = {}, -- Don't use default mappings as they are defined above
  },
}
