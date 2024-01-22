-- Neoscroll
--
-- A smooth scrolling Neovim plugin written in Lua.

return {
  "karb94/neoscroll.nvim",
  -- Use neoscroll's default mappings as lazy keys; using a "BufNewFile" or "BufReadPre" lazy
  -- event doesn't work well for some buffers like with Neogit
  -- For some reason, adding `ft = "*"` in the lazy keys causes Neoscroll to make Neovim crash
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
      "zt",
      desc = "Top this line",
    },
    {
      "zz",
      desc = "Center this line",
    },
    {
      "zb",
      desc = "Bottom this line",
    },
  },
  opts = {},
}
