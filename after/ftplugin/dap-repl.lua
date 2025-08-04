-- [[ Keymaps ]]

-- Keymaps to go through commmand history (<C-n> & <C-p> are used by completion, but <C-j> & <C-k> are not)
vim.keymap.set("i", "<C-j>", function() require("dap.repl").on_down() end, { desc = "Next command", buffer = true })
vim.keymap.set("i", "<C-k>", function() require("dap.repl").on_up() end, { desc = "Previous command", buffer = true })
