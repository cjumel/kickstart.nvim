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
vim.keymap.set("v", "<TAB>", ">gv", { desc = "Indent selection" })
vim.keymap.set("v", "<S-TAB>", "<gv", { desc = "Unindent selection" })

-- Shortcuts to access main registers
vim.keymap.set({ "n", "v" }, "+", '"+', { desc = "System copy register" })
vim.keymap.set({ "n", "v" }, "_", '"_', { desc = "Black hole copy register" })
vim.keymap.set({ "n", "v" }, "Q", "@q", { desc = "Default macro register" })

-- Diagnostics
-- They can be errors, warnings, information messages or hints
vim.keymap.set(
  { "n", "i" },
  "<C-^>", -- Actually <C-m> on my setup, but not <CR>
  vim.diagnostic.open_float,
  { desc = "More diagnostic" }
)
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

-- Move cursor to line start or end
-- Mnemonic: <C-e> is like "end" & <C-a> is like "ante", meaning before in Latin
vim.keymap.set({ "i", "c" }, "<C-e>", "<End>", { desc = "Move cursor to end of line" })
vim.keymap.set({ "i", "c" }, "<C-a>", "<Home>", { desc = "Move cursor to beginning of line" })

-- Move cursor one character left or right
-- Mnemonic: <C-b> is like "back" & <C-f> is like "forward"
vim.keymap.set({ "i", "c" }, "<C-b>", "<Left>", { desc = "Move cursor one character left" })
vim.keymap.set({ "i", "c" }, "<C-f>", "<Right>", { desc = "Move cursor one character right" })

-- [[ Settings keymaps ]]

vim.keymap.set("n", "<leader>,c", function()
  if vim.o.background == "dark" then
    vim.cmd("set background=light")
  else
    vim.cmd("set background=dark")
  end
end, { desc = "Settings: switch [C]olorscheme mode" })
vim.keymap.set("n", "<leader>,n", function()
  -- Switch between absolute to relative numbering
  if vim.wo.number and not vim.wo.relativenumber then
    vim.wo.relativenumber = true
  -- Switch between relative to no numbering
  elseif vim.wo.number and vim.wo.relativenumber then
    vim.wo.number = false
    vim.wo.relativenumber = false
  -- Switch between anything else to absolute numbering
  else
    vim.wo.number = true
    vim.wo.relativenumber = false
  end
end, { desc = "Settings: switch line [N]umbering mode" })
vim.keymap.set(
  "n",
  "<leader>,s",
  require("statusline").toggle,
  { desc = "Settings: toggle [S]tatus line" }
)

-- [[ Command line keymaps ]]

-- Use <c-p> and <c-n> to navigate through command line history matching the current input
vim.keymap.set("c", "<c-p>", "<up>")
vim.keymap.set("c", "<c-n>", "<down>")

-- vim: ts=2 sts=2 sw=2 et
