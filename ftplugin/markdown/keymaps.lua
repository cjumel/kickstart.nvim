local keymap = require("keymap")

-- In Markdown, Treesitter class navigation will actually navigate between headers, so this can be used directly for
--  this purpose

-- Use builtin sentence text-objects instead of custom sub-word ones
vim.keymap.set({ "x", "o" }, "is", "is", { desc = "inner sentence (Markdown)", buffer = true })
vim.keymap.set({ "x", "o" }, "as", "as", { desc = "a sentence (Markdown)", buffer = true })

-- Navigate between sentences instead of line siblings with Treesitter (the latter can be replaced by header navigation)
keymap.set_move_pair(
  { "[s", "]s" },
  { function() vim.cmd("normal )") end, function() vim.cmd("normal (") end },
  { { desc = "Next sentence (Markdown)", buffer = true }, { desc = "Previous sentence (Markdown)", buffer = true } }
)

-- Navigate between GitHub-flavored Markdown todo checkboxes (not started or in progress), instead of todo-comments
--  (which are not supported in Markdown by todo-comments.nvim anyway)
local todo_checkbox_pattern = "- \\[ ] \\|- \\[-] "
keymap.set_move_pair(
  { "[t", "]t" },
  { function() vim.fn.search(todo_checkbox_pattern) end, function() vim.fn.search(todo_checkbox_pattern, "b") end },
  {
    { desc = "Next todo checkbox (Markdown)", buffer = true },
    { desc = "Previous todo checkbox (Markdown)", buffer = true },
  }
)
