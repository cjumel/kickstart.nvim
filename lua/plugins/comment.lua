-- comment.nvim
--
-- Define many keymaps to comment code, using `gc` and others.

return {
  'numToStr/Comment.nvim',
  event = 'VeryLazy', -- Making it lazy will make keymaps unknown before loading
  opts = {},
}
