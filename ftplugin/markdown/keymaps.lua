local utils = require("utils")

-- [[ Modify existing keymaps ]]
-- In Markdown, Treesitter class navigation will actually navigate between headers

-- Use builtin sentence text-objects instead of custom sub-word ones
vim.keymap.set({ "x", "o" }, "is", "is", { desc = "inner sentence (Markdown)", buffer = true })
vim.keymap.set({ "x", "o" }, "as", "as", { desc = "a sentence (Markdown)", buffer = true })

-- Navigate between sentences instead of line siblings with Treesitter (the latter can be replaced by header navigation)
utils.keymap.set_move_pair(
  { "[s", "]s" },
  { function() vim.cmd("normal )") end, function() vim.cmd("normal (") end },
  { { desc = "Next sentence (Markdown)", buffer = true }, { desc = "Previous sentence (Markdown)", buffer = true } }
)

-- Navigate between todomojis instead of todo-comments (the latter are not supported in Markdown by todo-comments.nvim)
-- Todomojis: todo items with emojis
--  🎯 (:dart:) -> todo
--  ⌛ (:hourglass:) -> in progress
--  ✅ (:white_check_mark:) -> done
--  ❌ (:x:) -> cancelled
local todo_item_pattern = "[🎯⌛]" -- Look only for todo or in progress items, not done or cancelled
utils.keymap.set_move_pair(
  { "[t", "]t" },
  { function() vim.fn.search(todo_item_pattern) end, function() vim.fn.search(todo_item_pattern, "b") end },
  { { desc = "Next todomoji (Markdown)", buffer = true }, { desc = "Previous todomoji (Markdown)", buffer = true } }
)

-- [[ Introduce new keymaps ]]

-- Navigate between GitHub-flavored Markdown checkboxes
local checkbox_pattern = "- \\[ ]\\|- \\\\[ \\\\\\]" -- Handle both normal checkboxes & after mdformat formatting
utils.keymap.set_move_pair(
  { "[T", "]T" },
  { function() vim.fn.search(checkbox_pattern) end, function() vim.fn.search(checkbox_pattern, "b") end },
  {
    { desc = "Next todo checkbox (Markdown)", buffer = true },
    { desc = "Previous todo checkbox (Markdown)", buffer = true },
  }
)
