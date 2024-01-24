-- Neoscroll
--
-- A smooth scrolling Neovim plugin written in Lua.

return {
  "karb94/neoscroll.nvim",
  -- Using `event = { "BufNewFile", "BufReadPre" }` makes Neoscroll not activated in some buffers
  -- like Neogit's status
  keys = {
    -- Don't specify a filetype in the keys, it breaks the lazy loading (when lazy-loaded, only
    -- the trigger keymap works until the buffer is reloaded) and Neoscroll is not activated in
    -- some floating windows, like Gitsign's hunk preview
    -- Redefine the builtin keymaps description to make them displayed by Which Key
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
