-- comment.nvim
--
-- Define many keymaps to comment code, using `gc` and others.

return {
  "numToStr/Comment.nvim",
  event = { "BufNewFile", "BufReadPre" },
  opts = {},
}
