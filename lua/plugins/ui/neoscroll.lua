-- Neoscroll
--
-- A smooth scrolling Neovim plugin written in Lua.

return {
  "karb94/neoscroll.nvim",
  -- Use neoscroll's default mappings as lazy keys; using a "BufNewFile" or "BufReadPre" lazy
  -- event doesn't work well for some buffers like with Neogit
  keys = {
    {
      "<C-u>",
      desc = "Scroll up half of a window height",
      ft = "*",
    },
    {
      "<C-d>",
      desc = "Scroll down half of a window height",
      ft = "*",
    },
    {
      "<C-b>",
      desc = "Scroll up a window height",
      ft = "*",
    },
    {
      "<C-f>",
      desc = "Scroll down a window height",
      ft = "*",
    },
    {
      "<C-y>",
      desc = "Scroll up 10% of a window height",
      ft = "*",
    },
    {
      "<C-e>",
      desc = "Scroll down 10% of a window height",
      ft = "*",
    },
    {
      "zt",
      desc = "Top this line",
      ft = "*",
    },
    {
      "zz",
      desc = "Center this line",
      ft = "*",
    },
    {
      "zb",
      desc = "Bottom this line",
      ft = "*",
    },
  },
  opts = {},
}
