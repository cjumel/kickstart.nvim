local utils = require("utils")

-- [[ Modify existing keymaps ]]

-- Use builtin sentence text-objects instead of custom sub-word ones
vim.keymap.set({ "x", "o" }, "is", "is", { desc = "inner sentence (Markdown)", buffer = true })
vim.keymap.set({ "x", "o" }, "as", "as", { desc = "a sentence (Markdown)", buffer = true })

-- Navigate between sentences instead of Treesitter line siblings (the latter can be replaced by title navigation)
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
  { { desc = "Next todo item (Markdown)", buffer = true }, { desc = "Previous todo item (Markdown)", buffer = true } }
)

-- [[ Introduce new keymaps ]]

local title_pattern = "^#" -- Will also match some lines in code blocks (e.g. Python comments), but good enough
utils.keymap.set_move_pair(
  { "[#", "]#" },
  { function() vim.fn.search(title_pattern) end, function() vim.fn.search(title_pattern, "b") end },
  { { desc = "Next title (Markdown)", buffer = true }, { desc = "Previous title (Markdown)", buffer = true } }
)
