-- nvim-surround
--
-- A classic plugin to add, change, delete surrounding delimiter pairs with ease in Neovim, like tpope's vim-surround.

return {
  "kylechui/nvim-surround",
  keys = {
    { "ys", desc = "Add surrounds" },
    { "cs", desc = "Change surrounds" },
    { "ds", desc = "Delete surrounds" },
    { "S", mode = "x", desc = "Add surrounds" },
  },
  opts = {
    keymaps = {
      insert = false,
      insert_line = false,
      normal_cur = false,
      normal_line = false,
      normal_cur_line = false,
      visual_line = false,
      change_line = false,
    },
    -- Remove the white spaces introduced when using some of the surrounds
    surrounds = {
      ["("] = false,
      ["["] = false,
      ["{"] = false,
      ["<"] = false,
    },
    aliases = {
      ["("] = ")",
      ["["] = "]",
      ["{"] = "}",
      ["<"] = ">",
    },
  },
}
