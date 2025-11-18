-- [[ Keymaps ]]

local actions = require("config.actions")
local keymap = require("config.keymap")

keymap.set_buffer("n", "<localleader>r", "<cmd>RenderMarkdown toggle<CR>", { desc = "Toggle [R]endering" })

-- Navigate between GitHub-flavored Markdown todo checkboxes (not started or in progress), instead of todo-comments
local todo_checkbox_pattern = "- \\[ ] \\|- \\[-] \\|- \\[o] "
local function next_checkbox() vim.fn.search(todo_checkbox_pattern) end
local function prev_checkbox() vim.fn.search(todo_checkbox_pattern, "b") end
keymap.set_buffer_pair("t", next_checkbox, prev_checkbox, "todo checkbox (Markdown)")

local bufname = vim.api.nvim_buf_get_name(0)
if vim.startswith(bufname, "/private/var/folders/") then -- Temporary markdown files, like when creating a PR with `gh`
  keymap.set_buffer("n", "q", actions.quit, { desc = "Quit" })
end
