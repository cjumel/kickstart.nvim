-- [[ Basic keymaps ]]

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Disable builtin auto-completion keymaps (avoid writting letters when calling them)
vim.keymap.set("i", "<C-n>", "<Nop>", { silent = true })
vim.keymap.set("i", "<C-p>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Remap gg/G to go to buffer beginning/end instead of first/last line
vim.keymap.set({ "n", "o", "x" }, "gg", "gg0", { desc = "Beginning buffer" })
vim.keymap.set({ "n", "o", "x" }, "G", "G$", { desc = "End of buffer" })

-- Use tab in visual mode to indent
vim.keymap.set("v", "<tab>", ">gv", { desc = "Indent selection" })
vim.keymap.set("v", "<s-tab>", "<gv", { desc = "Unindent selection" })

-- Shortcuts to access main registers
vim.keymap.set({ "n", "v" }, "+", '"+', { desc = "System copy register" })
vim.keymap.set({ "n", "v" }, "_", '"_', { desc = "Black hole copy register" })
vim.keymap.set({ "n", "v" }, "Q", "@q", { desc = "Default macro register" })

-- Diagnostics
vim.keymap.set("n", "<leader>?", vim.diagnostic.open_float, { desc = "Expand diagnostic" })

-- UI switches
vim.keymap.set("n", "<leader>T", function()
  if vim.o.background == "dark" then
    vim.cmd("set background=light")
  else
    vim.cmd("set background=dark")
  end
end, { desc = "[T]heme switch" })
vim.keymap.set("n", "<leader>N", function()
  if vim.wo.relativenumber then
    vim.wo.relativenumber = false
  else
    vim.wo.relativenumber = true
  end
end, { desc = "[N]umbering switch" })

-- Quick files
vim.keymap.set("n", "<leader>qn", function()
  vim.cmd("edit ./notes.md")
end, { desc = "[Q]uick file: [N]otes" })
vim.keymap.set("n", "<leader>qp", function()
  vim.cmd("edit ./temp.py")
end, { desc = "[Q]uick file: [P]ython" })

-- Use <c-p> and <c-n> in command line to navigate through command line history matching the
-- current input
vim.keymap.set("c", "<c-p>", "<up>")
vim.keymap.set("c", "<c-n>", "<down>")

-- vim: ts=2 sts=2 sw=2 et
