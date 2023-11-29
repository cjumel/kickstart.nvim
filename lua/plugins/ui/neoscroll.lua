-- Neoscroll
--
-- A smooth scrolling Neovim plugin written in Lua.

return {
  "karb94/neoscroll.nvim",
  -- Can't be loaded on `event = { "BufNewFile", "BufReadPre" }` to work with plugins like Neogit
  event = "VeryLazy",
  opts = {},
}
