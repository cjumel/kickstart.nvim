-- Keymaps for terminal mode, when using the builtin terminal emulator or in ToggleTerm, for instance

-- Builtin keymap to exit terminal mode is <C-\\><C-n>, let's simplify it
vim.keymap.set({ "t" }, "<C-\\>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
