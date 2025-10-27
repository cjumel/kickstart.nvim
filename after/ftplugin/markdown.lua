-- [[ Keymaps ]]

---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param desc string
local function map(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = true }) end

map("n", "<localleader>r", "<cmd>RenderMarkdown toggle<CR>", "Toggle [R]endering")

local ts_repeatable_move = require("nvim-treesitter.textobjects.repeatable_move")

---@param key string
---@param next_fn function
---@param prev_fn function
---@param name string
---@param other_key string|nil
---@return nil
local function map_move_pair(key, next_fn, prev_fn, name, other_key)
  other_key = other_key or key
  next_fn, prev_fn = ts_repeatable_move.make_repeatable_move_pair(next_fn, prev_fn)
  map({ "n", "x", "o" }, "[" .. key, next_fn, "Next " .. name)
  map({ "n", "x", "o" }, "]" .. other_key, prev_fn, "Previous " .. name)
end

-- Navigate between GitHub-flavored Markdown todo checkboxes (not started or in progress), instead of todo-comments
local todo_checkbox_pattern = "- \\[ ] \\|- \\[-] \\|- \\[o] "
local function next_checkbox() vim.fn.search(todo_checkbox_pattern) end
local function prev_checkbox() vim.fn.search(todo_checkbox_pattern, "b") end
map_move_pair("t", next_checkbox, prev_checkbox, "todo checkbox (Markdown)")
