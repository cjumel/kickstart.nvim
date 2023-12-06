-- Neoscroll
--
-- A smooth scrolling Neovim plugin written in Lua.

return {
  "karb94/neoscroll.nvim",
  keys = {
    {
      "<C-u>",
      desc = "Scroll up half of a window height",
    },
    {
      "<C-d>",
      desc = "Scroll down half of a window height",
    },
    {
      "<C-b>",
      desc = "Scroll up a window height",
    },
    {
      "<C-f>",
      desc = "Scroll down a window height",
    },
    {
      "<C-y>",
      desc = "Scroll up 10% of a window height",
    },
    {
      "<C-e>",
      desc = "Scroll down 10% of a window height",
    },
    {
      "<BS>",
      function()
        require("neoscroll").scroll(-0.10, false, 100)
      end,
      desc = "Scroll up 10% of a window height",
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
    mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>" },
  },
}
