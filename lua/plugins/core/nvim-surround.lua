-- nvim-surround
--
-- Plugin to add, change, delete surrounding delimiter pairs with ease in Neovim. This very simple plugin is in my
-- opinion a must-have for any Neovim user.

return {
  "kylechui/nvim-surround",
  keys = {
    -- insert & insert_line features are not re-implemented as I don't find them super useful
    { "ys", "<Plug>(nvim-surround-normal)", desc = "Surround" },
    { "ysc", "<Plug>(nvim-surround-normal-cur)", desc = "Surround current line" },
    { "yS", "<Plug>(nvim-surround-normal-line)", desc = "Surround on new lines" },
    { "ySc", "<Plug>(nvim-surround-normal-cur-line)", desc = "Surround current line on new lines" },
    { "S", "<Plug>(nvim-surround-visual)", mode = "x", desc = "Surround" },
    { "<C-s>", "<Plug>(nvim-surround-visual-line)", mode = "x", desc = "Surround on new lines" },
    { "ds", "<Plug>(nvim-surround-delete)", desc = "Delete surrounds" },
    { "cs", "<Plug>(nvim-surround-change)", desc = "Change surrounds" },
    { "cS", "<Plug>(nvim-surround-change-line)", desc = "Change surrounds on new lines" },
  },
  opts = {
    keymaps = { -- Disable default keymaps, redefined as Lazy keys for lazy-loading & overwritting descriptions
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
