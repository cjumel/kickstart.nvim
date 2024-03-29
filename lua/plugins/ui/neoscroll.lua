-- Neoscroll
--
-- A smooth scrolling Neovim plugin written in Lua.

return {
  "karb94/neoscroll.nvim",
  keys = {
    -- Mappings used with the default options
    { "<C-u>", mode = { "n", "v" }, desc = "Scroll half a page up" },
    { "<C-d>", mode = { "n", "v" }, desc = "Scroll half a page down" },
    { "<C-b>", mode = { "n", "v" }, desc = "Scroll a page up" },
    { "<C-f>", mode = { "n", "v" }, desc = "Scroll a page down" },
    { "zt", mode = { "n", "v" }, desc = "Top this line" },
    { "zz", mode = { "n", "v" }, desc = "Center this line" },
    { "zb", mode = { "n", "v" }, desc = "Bottom this line" },

    -- For <C-y> & <C-e>, a relative number of lines to scroll (the default) doesn't work well in
    -- very small windows, whereas an absolute number of lines has no real drawback
    {
      "<C-y>",
      function()
        require("neoscroll").scroll(-5, false, 100) -- Defaults: -0.10, false, 100
      end,
      mode = { "n", "v" },
      desc = "Move window 5 lines up",
    },
    {
      "<C-e>",
      function()
        require("neoscroll").scroll(5, false, 100) -- Defaults: 0.10, false, 100
      end,
      mode = { "n", "v" },
      desc = "Move window 5 lines down",
    },

    -- Map arrow keys with Neoscroll to navigate within a document with only one hand
    {
      "<Left>",
      function()
        require("neoscroll").scroll(-vim.wo.scroll, false, 250)
      end,
      mode = { "n", "v" },
      desc = "Move window half a page up",
    },
    {
      "<Right>",
      function()
        require("neoscroll").scroll(vim.wo.scroll, false, 250)
      end,
      mode = { "n", "v" },
      desc = "Move window half a page down",
    },
    {
      "<Up>",
      function()
        require("neoscroll").scroll(-5, false, 100)
      end,
      mode = { "n", "v" },
      desc = "Move window 5 lines up",
    },
    {
      "<Down>",
      function()
        require("neoscroll").scroll(5, false, 100)
      end,
      mode = { "n", "v" },
      desc = "Move window 5 lines down",
    },
  },
  opts = {
    -- Define the mappings used with the default options
    mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
  },
}
