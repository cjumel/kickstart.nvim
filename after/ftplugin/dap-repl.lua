-- [[ Keymaps ]]

-- Keymaps to go through commmand history (<C-n> & <C-p> are used by completion)
vim.keymap.set("i", "<C-]>", function() require("dap.repl").on_up() end, { desc = "Previous command", buffer = true }) -- <C-$>
vim.keymap.set("i", "<C-\\>", function() require("dap.repl").on_down() end, { desc = "Next command", buffer = true }) -- <C-`>
