-- Neoscroll
--
-- A smooth scrolling Neovim plugin written in Lua.

return {
  "karb94/neoscroll.nvim",
  -- Using `event = { "BufNewFile", "BufReadPre" }` makes Neoscroll not activated in some buffers
  -- like Neogit's status
  event = "VeryLazy",
  keys = {
    -- Use regular scrolling features with Neoscroll
    { "<C-u>", mode = { "n", "v" }, desc = "Scroll up half of a window height" },
    { "<C-d>", mode = { "n", "v" }, desc = "Scroll down half of a window height" },
    { "<C-b>", mode = { "n", "v" }, desc = "Scroll up a window height" },
    { "<C-f>", mode = { "n", "v" }, desc = "Scroll down a window height" },
    { "<C-y>", mode = { "n", "v" }, desc = "Scroll up 10% of a window height (without cursor)" },
    { "<C-e>", mode = { "n", "v" }, desc = "Scroll down 10% of a window height (without cursor)" },
    { "zt", mode = { "n", "v" }, desc = "Top this line" },
    { "zz", mode = { "n", "v" }, desc = "Center this line" },
    { "zb", mode = { "n", "v" }, desc = "Bottom this line" },
    -- Use Neoscroll for up & down arrow keys
    {
      "<Up>",
      function()
        require("neoscroll").scroll(-5, false, 100)
      end,
      mode = { "n", "v" },
      desc = "Scroll up 5 lines",
    },
    {
      "<Down>",
      function()
        require("neoscroll").scroll(5, false, 100)
      end,
      mode = { "n", "v" },
      desc = "Scroll down 5 lines",
    },
  },
  opts = {},
}
