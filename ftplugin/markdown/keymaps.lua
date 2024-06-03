local utils = require("utils")

local title_pattern = "^#"
utils.keymap.set_move_pair(
  { "[#", "]#" },
  { function() vim.fn.search(title_pattern) end, function() vim.fn.search(title_pattern, "b") end },
  { { desc = "Next title", buffer = true }, { desc = "Previous title", buffer = true } }
)

utils.keymap.set_move_pair(
  { "[s", "]s" },
  { function() vim.cmd("normal )") end, function() vim.cmd("normal (") end },
  { { desc = "Next sentence", buffer = true }, { desc = "Previous sentence", buffer = true } }
)

-- Overwrite custom subword text-objects with builtin sentence ones
vim.keymap.set({ "x", "o" }, "is", "is", { desc = "inner sentence", buffer = true })
vim.keymap.set({ "x", "o" }, "as", "as", { desc = "a sentence", buffer = true })

local todo_item_pattern = "- [🎯⏳] " -- Don't look for items done or cancelled
utils.keymap.set_move_pair(
  { "[t", "]t" }, -- Correpond to todo-comments in other filetypes, but not used in Markdown
  { function() vim.fn.search(todo_item_pattern) end, function() vim.fn.search(todo_item_pattern, "b") end },
  { { desc = "Next todo item", buffer = true }, { desc = "Previous todo item", buffer = true } }
)
