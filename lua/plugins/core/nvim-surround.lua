-- nvim-surround
--
-- A classic plugin to add, change, delete surrounding delimiter pairs with ease in Neovim, like tpope's vim-surround.
-- This is a very simple plugin, yet using a surround plugin, like this one, is, in my opinion a must-have for any
-- Neovim user.

return {
  "kylechui/nvim-surround",
  -- Let's implemnt these keymaps using the lazy keys, as they provide more flexibility and support actual descriptions
  -- whereas the default keymaps don't
  keys = {
    { "ga", "<Plug>(nvim-surround-normal)", desc = "Add surrounds" },
    { "ga", "<Plug>(nvim-surround-visual)", mode = "x", desc = "Add surrounds" },
    { "gA", "<Plug>(nvim-surround-normal-line)", desc = "Add surrounds on new lines" },
    { "gm", "<Plug>(nvim-surround-change)", desc = "Modify surrounds" },
    { "gl", "<Plug>(nvim-surround-delete)", desc = "Lose surrounds" },
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
