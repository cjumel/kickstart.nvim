-- comment.nvim
--
-- Define many keymaps to comment code, using `gc` and others.

return {
  "numToStr/Comment.nvim",
  keys = {
    -- Basic mappings
    { "gc", "<Plug>(comment_toggle_linewise)", desc = "Comment linewise" },
    { "gcc", "<Plug>(comment_toggle_linewise_current)", desc = "Comment linewise current line" },
    { "gc", "<Plug>(comment_toggle_linewise_visual)", mode = "x", desc = "Comment linewise" },
    { "gb", "<Plug>(comment_toggle_blockwise)", desc = "Comment blockwise" },
    { "gbc", "<Plug>(comment_toggle_blockwise_current)", desc = "Comment blockwise current block" },
    { "gb", "<Plug>(comment_toggle_blockwise_visual)", mode = "x", desc = "Comment blockwise" },
    -- Extra Mappings
    { "gco", function() require("Comment.api").insert.linewise.below() end, desc = "Comment insert below" },
    { "gcO", function() require("Comment.api").insert.linewise.above() end, desc = "Comment insert above" },
    { "gcA", function() require("Comment.api").insert.linewise.eol() end, desc = "Comment insert end of line" },
  },
  opts = {
    -- Disable default keymaps, redefined as Lazy keys for lazy-loading & overwritting descriptions
    mappings = { basic = false, extra = false },
  },
}
