-- [[ Keymaps ]]

local map = require("config.utils").map_buffer

map("n", "<localleader>r", "<cmd>RenderMarkdown toggle<CR>", { desc = "Toggle [R]endering" })

-- Navigate between GitHub-flavored Markdown todo checkboxes (not started or in progress), instead of todo-comments
local pattern = "- \\[ ] \\|- \\[-] \\|- \\[o] "
map({ "n", "x", "o" }, "]t", function() vim.fn.search(pattern) end, { desc = "Next todo checkbox (Markdown)" })
map({ "n", "x", "o" }, "[t", function() vim.fn.search(pattern, "b") end, { desc = "Previous todo checkbox (Markdown)" })
