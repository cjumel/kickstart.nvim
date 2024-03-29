-- Neoscroll
--
-- A smooth scrolling Neovim plugin written in Lua.

local function c_u()
  require("neoscroll").scroll(-vim.wo.scroll, true, 250) -- Defaults
end
local function c_d()
  require("neoscroll").scroll(vim.wo.scroll, true, 250) -- Defaults
end

-- For <C-y> & <C-e>, a relative number of lines to scroll (the default) doesn't work well in very
-- small windows, whereas an absolute number of lines has no real drawback for me
local function c_y()
  require("neoscroll").scroll(-5, false, 100) -- Defaults: -0.10, false, 100
end
local function c_e()
  require("neoscroll").scroll(5, false, 100) -- Defaults: 0.10, false, 100
end

return {
  "karb94/neoscroll.nvim",
  -- Using `event = { "BufNewFile", "BufReadPre" }` makes Neoscroll not activated in some buffers
  -- like Neogit's status
  event = "VeryLazy",
  keys = {
    -- Use regular scrolling features with Neoscroll
    { "<C-u>", c_u, mode = { "n", "v" }, desc = "Scroll up half a page" },
    { "<C-d>", c_d, mode = { "n", "v" }, desc = "Scroll down half a page" },
    { "<C-b>", mode = { "n", "v" }, desc = "Scroll up a page" },
    { "<C-f>", mode = { "n", "v" }, desc = "Scroll down a page" },
    { "<C-y>", c_y, mode = { "n", "v" }, desc = "Move window 5 lines up" },
    { "<C-e>", c_e, mode = { "n", "v" }, desc = "Move window 5 lines down" },
    { "zt", mode = { "n", "v" }, desc = "Top this line" },
    { "zz", mode = { "n", "v" }, desc = "Center this line" },
    { "zb", mode = { "n", "v" }, desc = "Bottom this line" },
    -- Map arrow keys to Neoscroll features to navigate within a document with only one hand
    { "<Left>", c_u, mode = { "n", "v" }, desc = "Scroll up half a page" },
    { "<Right>", c_d, mode = { "n", "v" }, desc = "Scroll down half a page" },
    { "<Up>", c_y, mode = { "n", "v" }, desc = "Move window 5 lines up" },
    { "<Down>", c_e, mode = { "n", "v" }, desc = "Move window 5 lines down" },
  },
  opts = {
    mappings = { "<C-b>", "<C-f>", "zt", "zz", "zb" }, -- Only those which are not redefined above
  },
}
