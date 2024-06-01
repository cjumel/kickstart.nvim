local utils = require("utils")

local todo_item_pattern = "- [🎯⏳] " -- Don't look for items done or cancelled
utils.keymap.set_move_pair(
  { "[t", "]t" }, -- Correpond to todo-comments in other filetypes, but not used in Markdown
  { function() vim.fn.search(todo_item_pattern) end, function() vim.fn.search(todo_item_pattern, "b") end },
  { { desc = "Next todo item", buffer = true }, { desc = "Previous todo item", buffer = true } }
)
