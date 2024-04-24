-- nvim-surround
--
-- Provide tools to surround or modify surroundings efficiently, juste like vim-surround.

return {
  "kylechui/nvim-surround",
  keys = {
    -- insert & insert_line are not re-implemented as they're not super useful in practice
    { "ys", "<Plug>(nvim-surround-normal)", desc = "Surround" },
    { "ysc", "<Plug>(nvim-surround-normal-cur)", desc = "Surround current line" },
    { "yS", "<Plug>(nvim-surround-normal-line)", desc = "Surround on new lines" },
    { "ySc", "<Plug>(nvim-surround-normal-cur-line)", desc = "Surround current line on new lines" },
    { "S", "<Plug>(nvim-surround-visual)", mode = "x", desc = "Surround" },
    { "gS", "<Plug>(nvim-surround-visual-line)", mode = "x", desc = "Surround on new lines" },
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
