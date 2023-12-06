-- Neoscroll
--
-- A smooth scrolling Neovim plugin written in Lua.

return {
  "karb94/neoscroll.nvim",
  -- Can't be loaded on `event = { "BufNewFile", "BufReadPre" }` to work with plugins like Neogit
  event = "VeryLazy",
  keys = {
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
  opts = {},
}
