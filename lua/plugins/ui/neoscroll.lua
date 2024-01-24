-- Neoscroll
--
-- A smooth scrolling Neovim plugin written in Lua.

return {
  "karb94/neoscroll.nvim",
  -- Using `event = { "BufNewFile", "BufReadPre" }` makes Neoscroll not activated in some buffers
  -- like Neogit's status
  keys = {
    { "<C-u>", desc = "Scroll up half of a window height" },
    { "<C-d>", desc = "Scroll down half of a window height" },
    { "<C-b>", desc = "Scroll up a window height" },
    { "<C-f>", desc = "Scroll down a window height" },
    { "<C-y>", desc = "Scroll up 10% of a window height" },
    { "<C-e>", desc = "Scroll down 10% of a window height" },
    { "zt", desc = "Top this line" },
    { "zz", desc = "Center this line" },
    { "zb", desc = "Bottom this line" },
  },
  opts = {},
}
