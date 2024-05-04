-- marks.nvim
--
-- marks.nvim provides a better user experience for interacting with and manipulating Vim & Neovim marks. Such a plugin
-- is, in my opinion, essential to use marks, as it provides the missing features of Neovim marks, like visualizing
-- them in the sign column or some handy keymaps to delete them, for instance.
--
-- Note that there is a known issue with mark deletion being not permanent (hence polluting buffers when shown in the
-- sign column), which requires Neovim v0.10 to be solved, or a nightly version.

return {
  "chentoast/marks.nvim",
  event = { "BufNewFile", "BufReadPre" },
  keys = function() -- Defining manually keymaps (instead of in options) is the only way to add descriptions
    local marks = require("marks")
    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

    local next_mark, prev_mark = ts_repeat_move.make_repeatable_move_pair(marks.next, marks.prev)

    return {
      { "m", marks.set, desc = "Set mark" },
      { "m<Space>", marks.set_next, desc = "Set next available mark" },
      { "dm", marks.delete, desc = "Delete mark" },
      { "dm<Space>", marks.delete_line, desc = "Delete line marks" },
      { "dm<CR>", marks.delete_buf, desc = "Delete buffer marks" },
      { "[`", next_mark, desc = "Next mark" },
      { "]`", prev_mark, desc = "Previous mark" },
    }
  end,
  opts = {
    default_mappings = false,
  },
}
