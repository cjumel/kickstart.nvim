-- Neoscroll
--
-- Neoscroll is a smooth scrolling Neovim plugin written in Lua. It makes scrolling in Neovim far easier on the eyes,
-- as one can follow a line of text while scrolling, whereas the default scrolling behavior makes the text disappear
-- and reappear at another place, making it super hard to follow in my opinion.

return {
  "karb94/neoscroll.nvim",
  keys = function()
    local function c_u() require("neoscroll").ctrl_u({ duration = 250 }) end
    local function c_d() require("neoscroll").ctrl_d({ duration = 250 }) end
    local function c_b() require("neoscroll").ctrl_b({ duration = 450 }) end
    local function c_f() require("neoscroll").ctrl_f({ duration = 450 }) end

    local function c_y() require("neoscroll").scroll(-5, { move_cursor = false, duration = 100 }) end
    local function c_e() require("neoscroll").scroll(5, { move_cursor = false, duration = 100 }) end

    local function zt() require("neoscroll").zt({ half_win_duration = 250 }) end
    local function zz() require("neoscroll").zz({ half_win_duration = 250 }) end
    local function zb() require("neoscroll").zb({ half_win_duration = 250 }) end

    return {
      { "<C-u>", c_u, mode = { "n", "v", "x" }, desc = "Scroll half a page up" },
      { "<C-d>", c_d, mode = { "n", "v", "x" }, desc = "Scroll half a page down" },
      { "<C-b>", c_b, mode = { "n", "v", "x" }, desc = "Scroll a page up" },
      { "<C-f>", c_f, mode = { "n", "v", "x" }, desc = "Scroll a page down" },

      { "<C-y>", c_y, mode = { "n", "v", "x" }, desc = "Scroll a few lines up" },
      { "<C-e>", c_e, mode = { "n", "v", "x" }, desc = "Scroll a few lines down" },

      { "zt", zt, mode = { "n", "v", "x" }, desc = "Top this line" },
      { "zz", zz, mode = { "n", "v", "x" }, desc = "Center this line" },
      { "zb", zb, mode = { "n", "v", "x" }, desc = "Bottom this line" },

      -- Map arrow keys to navigate within a document with only one hand on the keyboard
      { "<Up>", c_y, mode = { "n", "v", "x" }, desc = "Scroll a few lines up" },
      { "<Down>", c_e, mode = { "n", "v", "x" }, desc = "Scroll a few lines down" },
      { "<Left>", c_u, mode = { "n", "v", "x" }, desc = "Scroll half a page up" },
      { "<Right>", c_d, mode = { "n", "v", "x" }, desc = "Scroll half a page down" },
    }
  end,
  opts = {
    mappings = {}, -- Don't use default mappings as they are defined above
  },
}
