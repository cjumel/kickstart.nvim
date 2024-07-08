local utils = require("utils")

local title_pattern = "^#"
utils.keymap.set_move_pair(
  { "[#", "]#" },
  { function() vim.fn.search(title_pattern) end, function() vim.fn.search(title_pattern, "b") end },
  { { desc = "Next title (Markdown)", buffer = true }, { desc = "Previous title (Markdown)", buffer = true } }
)

utils.keymap.set_move_pair(
  { "[s", "]s" },
  { function() vim.cmd("normal )") end, function() vim.cmd("normal (") end },
  { { desc = "Next sentence (Markdown)", buffer = true }, { desc = "Previous sentence (Markdown)", buffer = true } }
)

-- Overwrite custom subword text-objects with builtin sentence ones
vim.keymap.set({ "x", "o" }, "is", "is", { desc = "inner sentence (Markdown)", buffer = true })
vim.keymap.set({ "x", "o" }, "as", "as", { desc = "a sentence (Markdown)", buffer = true })

-- Navigate to emojis representing todo items
local todo_item_pattern = "[🎯⌛]" -- Look only for todo or in progress items, not done or cancelled
utils.keymap.set_move_pair(
  { "[t", "]t" }, -- Correpond to todo-comments in other filetypes, but not used in Markdown
  { function() vim.fn.search(todo_item_pattern) end, function() vim.fn.search(todo_item_pattern, "b") end },
  { { desc = "Next todo item (Markdown)", buffer = true }, { desc = "Previous todo item (Markdown)", buffer = true } }
)
