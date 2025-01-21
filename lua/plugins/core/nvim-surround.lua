-- nvim-surround
--
-- A classic plugin to add, change, delete surrounding delimiter pairs with ease in Neovim, like tpope's vim-surround.
-- This is a very simple plugin, yet using a surround plugin, like this one, is, in my opinion a must-have for any
-- Neovim user.

return {
  "kylechui/nvim-surround",
  -- Let's implemnt these keymaps using the lazy keys, as they provide more flexibility and support actual descriptions
  -- (whereas the default keymaps don't)
  -- Let's use the "(" and ")" keys interchangeably as general prefix for these keymaps:
  -- - nvim-surround (and vim-surround) use by default "ys", "cs" or "ds", but these conflicts with existing builtin
  -- keymaps, which makes them in practice not very practical, as you have to type the sequence of keys up until the
  -- surrounding character (e.g. 'ysaw"') very quickly
  -- - mini.surround use "s" as a general prefix, I already use "s", but let's re-use the same idea of general prefix
  -- - I don't use the builtin "(" and ")" (next/previous sentence), so let's recycle it
  keys = {
    { "(a", "<Plug>(nvim-surround-normal)", desc = "Add surrounds" },
    { ")a", "<Plug>(nvim-surround-normal)", desc = "Add surrounds" },
    { "(n", "<Plug>(nvim-surround-normal-line)", desc = "Add surrounds on new lines" },
    { ")n", "<Plug>(nvim-surround-normal-line)", desc = "Add surrounds on new lines" },
    { "(c", "<Plug>(nvim-surround-change)", desc = "Change surrounds" },
    { ")c", "<Plug>(nvim-surround-change)", desc = "Change surrounds" },
    { "(d", "<Plug>(nvim-surround-delete)", desc = "Delete surrounds" },
    { ")d", "<Plug>(nvim-surround-delete)", desc = "Delete surrounds" },
    { "(", "<Plug>(nvim-surround-visual)", mode = "x", desc = "Add surrounds" },
  },
  opts = {
    keymaps = {
      insert = false,
      insert_line = false,
      normal = false,
      normal_cur = false,
      normal_line = false,
      normal_cur_line = false,
      visual = false,
      visual_line = false,
      delete = false,
      change = false,
      change_line = false,
    },
  },
}
