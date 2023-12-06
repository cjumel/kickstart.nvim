-- Neoscroll
--
-- A smooth scrolling Neovim plugin written in Lua.

return {
  "karb94/neoscroll.nvim",
  keys = {
    {
      "<C-u>",
      function()
        require("neoscroll").scroll(-vim.wo.scroll, true, 250)
      end,
      desc = "Scroll up half of a window height",
    },
    {
      "<C-d>",
      function()
        require("neoscroll").scroll(vim.wo.scroll, true, 250)
      end,
      desc = "Scroll down half of a window height",
    },
    {
      "<C-b>",
      function()
        require("neoscroll").scroll(-vim.api.nvim_win_get_height(0), true, 450)
      end,
      desc = "Scroll up a window height",
    },
    {
      "<C-f>",
      function()
        require("neoscroll").scroll(vim.api.nvim_win_get_height(0), true, 450)
      end,
      desc = "Scroll down a window height",
    },
    {
      "<C-y>",
      function()
        require("neoscroll").scroll(-0.10, false, 100)
      end,
      desc = "Scroll up 10% of a window height",
    },
    {
      "<BS>",
      function()
        require("neoscroll").scroll(-0.10, false, 100)
      end,
      desc = "Scroll up 10% of a window height",
    },
    {
      "<C-e>",
      function()
        require("neoscroll").scroll(0.10, false, 100)
      end,
      desc = "Scroll down 10% of a window height",
    },
    {
      "<CR>",
      function()
        require("neoscroll").scroll(0.10, false, 100)
      end,
      desc = "Scroll down 10% of a window height",
    },
  },
  opts = {
    mappings = {}, -- Disable default mappings as mappings are defined in keys
  },
}
