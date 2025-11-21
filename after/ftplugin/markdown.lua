-- [[ Keymaps ]]

local actions = require("config.actions")
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
local next_checkbox, prev_checkbox = ts_repeat_move.make_repeatable_move_pair(
  function() vim.fn.search(todo_checkbox_pattern) end,
  function() vim.fn.search(todo_checkbox_pattern, "b") end
)
map({ "n", "x", "o" }, "]t", next_checkbox, { desc = "Next checkbox (Markdown)" })
map({ "n", "x", "o" }, "[t", prev_checkbox, { desc = "Previous checkbox (Markdown)" })

local bufname = vim.api.nvim_buf_get_name(0)
if vim.startswith(bufname, "/private/var/folders/") then -- Temporary markdown files, like when creating a PR with `gh`
  map("n", "q", actions.quit, { desc = "Quit" })
end
