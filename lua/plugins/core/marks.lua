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
  opts = {
    default_mappings = false,
  },
  config = function(_, opts)
    local marks = require("marks")
    local utils = require("utils")

    marks.setup(opts)

    -- Defining manually keymaps (instead of in options) is the only way to add descriptions
    vim.keymap.set("n", "m", marks.set, { desc = "Set mark" })
    vim.keymap.set("n", "m<Space>", marks.set_next, { desc = "Set next available mark" })
    vim.keymap.set("n", "dm", marks.delete, { desc = "Delete mark" })
    vim.keymap.set("n", "dm<Space>", marks.delete_line, { desc = "Delete line marks" })
    vim.keymap.set("n", "dm<CR>", marks.delete_buf, { desc = "Delete buffer marks" })
    utils.keymap.set_move_pair(
      { "[`", "]`" },
      { marks.next, marks.prev },
      { { desc = "Next mark" }, { desc = "Previous mark" } }
    )
  end,
}
