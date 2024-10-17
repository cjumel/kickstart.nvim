-- In Markdown, Treesitter class navigation will actually navigate between headers, so this can be used directly for
--  this purpose

-- Use builtin sentence text-objects instead of custom sub-word ones
vim.keymap.set({ "x", "o" }, "is", "is", { desc = "inner sentence (Markdown)", buffer = true })
vim.keymap.set({ "x", "o" }, "as", "as", { desc = "a sentence (Markdown)", buffer = true })
