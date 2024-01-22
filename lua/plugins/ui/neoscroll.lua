-- Neoscroll
--
-- A smooth scrolling Neovim plugin written in Lua.

return {
  "karb94/neoscroll.nvim",
  -- Use neoscroll's default mappings as lazy keys; using a "BufNewFile" or "BufReadPre" lazy
  -- event doesn't work well for some buffers like with Neogit
  -- Redefine the default mappings' functions to use `ft = "*"`, otherwise it makes Lazy crash
  keys = {
    {
      "<C-u>",
      function()
        require("neoscroll").scroll(-vim.wo.scroll, true, 350)
      end,
      desc = "Scroll up half of a window height",
      ft = "*",
    },
    {
      "<C-d>",
      function()
        require("neoscroll").scroll(vim.wo.scroll, true, 350)
      end,
      desc = "Scroll down half of a window height",
      ft = "*",
    },
    {
      "<C-b>",
      function()
        require("neoscroll").scroll(-vim.api.nvim_win_get_height(0), true, 550)
      end,
      desc = "Scroll up a window height",
      ft = "*",
    },
    {
      "<C-f>",
      function()
        require("neoscroll").scroll(vim.api.nvim_win_get_height(0), true, 550)
      end,
      desc = "Scroll down a window height",
      ft = "*",
    },
    {
      "<C-y>",
      function()
        require("neoscroll").scroll(-0.10, false, 100)
      end,
      desc = "Scroll up 10% of a window height",
      ft = "*",
    },
    {
      "<C-e>",
      function()
        require("neoscroll").scroll(0.10, false, 100)
      end,
      desc = "Scroll down 10% of a window height",
      ft = "*",
    },
    {
      "zt",
      function()
        require("neoscroll").zt(200)
      end,
      desc = "Top this line",
      ft = "*",
    },
    {
      "zz",
      function()
        require("neoscroll").zz(200)
      end,
      desc = "Center this line",
      ft = "*",
    },
    {
      "zb",
      function()
        require("neoscroll").zb(200)
      end,
      desc = "Bottom this line",
      ft = "*",
    },
  },
  opts = {
    mappings = {}, -- Disable all default mappings as they are redefined above with keys
  },
}
