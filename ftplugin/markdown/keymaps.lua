local utils = require("utils")

local title_pattern = "^#" -- Also catches comments with `#` in code blocks (e.g. in Python), but this is good enough
local todo_pattern = "- 🎯 \\|- ⏳ " -- Don't look for todo-items done or cancelled

utils.keymap.set_move_pair(
  { "[[", "][" }, -- Correspond to classes in other filetypes, but not in Markdown
  { function() vim.fn.search(title_pattern) end, function() vim.fn.search(title_pattern, "b") end },
  { { desc = "Next title", buffer = true }, { desc = "Previous title", buffer = true } }
)

utils.keymap.set_move_pair(
  { "[t", "]t" }, -- Correpond to todo-comments in other filetypes, but not in Markdown
  { function() vim.fn.search(todo_pattern) end, function() vim.fn.search(todo_pattern, "b") end },
  { { desc = "Next todo item", buffer = true }, { desc = "Previous todo item", buffer = true } }
)
