-- [[ Keymaps ]]

vim.keymap.set("n", ",", "}", { desc = "Next hunk", remap = true, buffer = true })
vim.keymap.set("n", ";", "{", { desc = "Previous hunk", remap = true, buffer = true })
