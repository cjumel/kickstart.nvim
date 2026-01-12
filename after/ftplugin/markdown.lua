-- [[ Keymaps ]]

local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts table
local function map(mode, lhs, rhs, opts)
  opts.buffer = true
  vim.keymap.set(mode, lhs, rhs, opts)
end

map("n", "<localleader>r", "<cmd>RenderMarkdown toggle<CR>", { desc = "Toggle [R]endering" })

-- Navigate between GitHub-flavored Markdown todo checkboxes (not started or in progress), instead of todo-comments
local todo_checkbox_pattern = "- \\[ ] \\|- \\[-] \\|- \\[o] "
local next_todo_checkbox, prev_todo_checkbox = ts_repeat_move.make_repeatable_move_pair(
  function() vim.fn.search(todo_checkbox_pattern) end,
  function() vim.fn.search(todo_checkbox_pattern, "b") end
)
map({ "n", "x", "o" }, "]t", next_todo_checkbox, { desc = "Next todo checkbox (Markdown)" })
map({ "n", "x", "o" }, "[t", prev_todo_checkbox, { desc = "Previous todo checkbox (Markdown)" })
