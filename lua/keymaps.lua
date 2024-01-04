-- [[ Basic keymaps ]]

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Disable builtin auto-completion keymaps (avoid writting letters when calling them)
vim.keymap.set("i", "<C-n>", "<Nop>", { silent = true })
vim.keymap.set("i", "<C-p>", "<Nop>", { silent = true })

-- Remap to automatically indent on empty line
vim.keymap.set("n", "a", function()
  return string.match(vim.api.nvim_get_current_line(), "%g") == nil and "cc" or "a"
end, { desc = "Neovim builtin", expr = true, noremap = true })
vim.keymap.set("n", "i", function()
  return string.match(vim.api.nvim_get_current_line(), "%g") == nil and "cc" or "i"
end, { desc = "Neovim builtin", expr = true, noremap = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Remap gg/G to go to buffer beginning/end instead of first/last line
vim.keymap.set({ "n", "o", "x" }, "gg", "gg0", { desc = "Beginning buffer" })
vim.keymap.set({ "n", "o", "x" }, "G", "G$", { desc = "End of buffer" })

-- Use tab in visual mode to indent
vim.keymap.set("v", "<TAB>", ">gv", { desc = "Indent selection" })
vim.keymap.set("v", "<S-TAB>", "<gv", { desc = "Unindent selection" })

-- Shortcuts to access main registers
vim.keymap.set({ "n", "v" }, "+", '"+', { desc = "System copy register" })
vim.keymap.set({ "n", "v" }, "_", '"_', { desc = "Black hole copy register" })
vim.keymap.set({ "n", "v" }, "Q", "@q", { desc = "Default macro register" })

-- Diagnostics
-- They can be errors, warnings, information messages or hints
vim.keymap.set({ "n" }, "<leader>m", vim.diagnostic.open_float, { desc = "[M]ore diagnostic" })
local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
local next_diagnostic, prev_diagnostic =
  ts_repeat_move.make_repeatable_move_pair(vim.diagnostic.goto_next, vim.diagnostic.goto_prev)
vim.keymap.set({ "n", "x", "o" }, "[d", next_diagnostic, { desc = "Next diagnostic" })
vim.keymap.set({ "n", "x", "o" }, "]d", prev_diagnostic, { desc = "Previous diagnostic" })
local next_error, prev_error = ts_repeat_move.make_repeatable_move_pair(function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end)
vim.keymap.set({ "n", "x", "o" }, "[e", next_error, { desc = "Next error" })
vim.keymap.set({ "n", "x", "o" }, "]e", prev_error, { desc = "Previous error" })

-- [[ Terminal-like keymaps ]]
-- Keymaps for insert & command line modes to emulate terminal-like behavior

-- Move cursor one character left or right
-- Mnemonic: <C-b> is like "back" & <C-f> is like "forward"
vim.keymap.set({ "i", "c" }, "<C-b>", "<Left>", { desc = "Move cursor one character left" })
vim.keymap.set({ "i", "c" }, "<C-f>", "<Right>", { desc = "Move cursor one character right" })

-- Move cursor one word left or right
vim.keymap.set(
  { "i", "c" },
  "<C-^>", -- Actually <C-%> on my setup
  "<C-Left>",
  { desc = "Move cursor one word left" }
)
vim.keymap.set(
  { "i", "c" },
  "<C-_>", -- Actually <C-`> on my setup
  "<C-Right>",
  { desc = "Move cursor one word right" }
)

-- Move cursor to line start or end
-- Mnemonic: <C-e> is like "end" & <C-a> is like "ante", meaning before in Latin
vim.keymap.set({ "i", "c" }, "<C-e>", "<End>", { desc = "Move cursor to end of line" })
vim.keymap.set({ "i", "c" }, "<C-a>", "<Home>", { desc = "Move cursor to beginning of line" })

-- [[ Settings keymaps ]]

vim.keymap.set("n", "<leader>,c", function()
  if vim.o.background == "dark" then
    vim.cmd("set background=light")
  else
    vim.cmd("set background=dark")
  end
  -- For an unknown reason, this function changes the status line, so we need to reset it
  vim.o.laststatus = 3 -- Use a global status line & a thin line to separate splits
end, { desc = "Settings: switch [C]olorscheme mode" })
vim.keymap.set("n", "<leader>,n", function()
  if vim.wo.number and not vim.wo.relativenumber then
    vim.wo.relativenumber = true
  elseif vim.wo.number and vim.wo.relativenumber then
    vim.wo.number = false
    vim.wo.relativenumber = false
  else
    vim.wo.number = true
    vim.wo.relativenumber = false
  end
end, { desc = "Settings: switch line [N]umbering mode" })
vim.keymap.set("n", "<leader>,s", function()
  if vim.wo.signcolumn == "number" then
    vim.wo.signcolumn = "yes"
  elseif vim.wo.signcolumn == "yes" then
    vim.wo.signcolumn = "no"
  else
    vim.wo.signcolumn = "number"
  end
end, { desc = "Settings: switch [S]ign column mode" })

-- vim: ts=2 sts=2 sw=2 et
