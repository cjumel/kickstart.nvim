-- [[ Keymaps ]]

local keymap = require("config.keymap")

keymap.set_buffer("n", "<localleader>r", "<cmd>RenderMarkdown toggle<CR>", { desc = "Toggle [R]endering" })

-- Navigate between GitHub-flavored Markdown todo checkboxes (not started or in progress), instead of todo-comments
local todo_checkbox_pattern = "- \\[ ] \\|- \\[-] \\|- \\[o] "
local function next_checkbox() vim.fn.search(todo_checkbox_pattern) end
local function prev_checkbox() vim.fn.search(todo_checkbox_pattern, "b") end
keymap.set_buffer_pair("t", next_checkbox, prev_checkbox, "todo checkbox (Markdown)")
