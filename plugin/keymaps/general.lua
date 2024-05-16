-- General keymaps

vim.keymap.set("n", "<leader><CR>", vim.diagnostic.open_float, { desc = "Open diagnostics" })

vim.keymap.set("n", "<Esc>", "<cmd>ClearWindow<CR>", { desc = "Clear" }) -- <Esc> is only available in normal mode
vim.keymap.set("v", "<C-c>", "<cmd>ClearWindow<CR>", { desc = "Clear" })
vim.keymap.set("i", "<C-c>", "<cmd>ClearAll<CR>", { desc = "Clear" })
vim.keymap.set("c", "<C-c>", "<cmd>ClearInsertMode<CR>", { desc = "Clear" }) -- Don't clean the cmdline popup itself

-- Use <C-i> to indent in visual mode, & <C-o> because it's next to it
vim.keymap.set("v", "<C-i>", ">gv", { desc = "Indent selection" })
vim.keymap.set("v", "<C-o>", "<gv", { desc = "Unindent selection" })

-- Shortcuts for quicker access to some of the main registers
vim.keymap.set({ "n", "v" }, "+", '"+', { desc = "System clipboard register" })
vim.keymap.set({ "n", "v" }, "_", '"_', { desc = "Black hole register" })
vim.keymap.set({ "n", "v" }, "Q", "@q", { desc = "Run macro from default register" })

vim.keymap.set("n", "<leader>ax", "<cmd>bufdo bd<CR>", { desc = "[A]ctions: close all buffers" })
