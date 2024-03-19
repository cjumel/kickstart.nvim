-- [[ Disable builtin keymaps ]]

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Disable builtin auto-completion keymaps (avoid writting letters when calling them)
vim.keymap.set("i", "<C-n>", "<Nop>", { silent = true })
vim.keymap.set("i", "<C-p>", "<Nop>", { silent = true })

-- Disable arrow keys's builtin bindings
vim.keymap.set({ "n", "v" }, "<Up>", "<Nop>", { silent = true })
vim.keymap.set({ "n", "v" }, "<Down>", "<Nop>", { silent = true })
vim.keymap.set({ "n", "v" }, "<Left>", "<Nop>", { silent = true })
vim.keymap.set({ "n", "v" }, "<Right>", "<Nop>", { silent = true })

-- Disable builtin navigation keymaps and don't show them in Which Key
vim.keymap.set("n", "[%", function() end, { desc = "which_key_ignore" })
vim.keymap.set("n", "]%", function() end, { desc = "which_key_ignore" })
vim.keymap.set("n", "[(", function() end, { desc = "which_key_ignore" })
vim.keymap.set("n", "](", function() end, { desc = "which_key_ignore" })
vim.keymap.set("n", "[<", function() end, { desc = "which_key_ignore" })
vim.keymap.set("n", "]<", function() end, { desc = "which_key_ignore" })
vim.keymap.set("n", "[{", function() end, { desc = "which_key_ignore" })
vim.keymap.set("n", "]{", function() end, { desc = "which_key_ignore" })
vim.keymap.set("n", "[m", function() end, { desc = "which_key_ignore" })
vim.keymap.set("n", "]m", function() end, { desc = "which_key_ignore" })
vim.keymap.set("n", "[M", function() end, { desc = "which_key_ignore" })
vim.keymap.set("n", "]M", function() end, { desc = "which_key_ignore" })

-- [[ Remap builtin keymaps ]]

local actions = require("actions")

-- Remap a/i to automatically indent on empty line
vim.keymap.set("n", "a", actions.smart_a, { desc = "Neovim builtin", expr = true, noremap = true })
vim.keymap.set("n", "i", actions.smart_i, { desc = "Neovim builtin", expr = true, noremap = true })

-- Remap dd to avoid saving empty lines in register
vim.keymap.set("n", "dd", actions.smart_dd, { desc = "Line", expr = true, noremap = true })

-- Remap j/k to deal with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Remap gg/G to go to buffer beginning/end instead of first/last line
vim.keymap.set({ "n", "o", "x" }, "gg", "gg0", { desc = "Beginning buffer" })
vim.keymap.set({ "n", "o", "x" }, "G", "G$", { desc = "End of buffer" })

-- Remap $ in visual mode to avoid selecting the newline character (consistent with other modes)
vim.keymap.set("v", "$", "$h", { desc = "End of line" })

-- Make zf detected by Which Key in visual mode
vim.keymap.set("v", "zf", "zf", { desc = "Create fold" })

-- Fix gx keymap
-- `gx` actually open both paths & URLs with the system's default application (typically the Finder
-- or a web broser, for MacOS), but I prefer to use `gf` to open paths with Neovim and keep `gx`
-- only to open URLs in a web browser
vim.api.nvim_set_keymap("n", "gx", actions.fixed_gx, { desc = "Open URL under cursor in browser" })

-- [[ General keymaps ]]

vim.keymap.set("n", "<ESC>", actions.clear_window, { desc = "Dismiss messages & floating windows" })
vim.keymap.set(
  { "i", "v" },
  "<C-c>",
  actions.clear_window,
  { desc = "Dismiss messages & floating windows" }
)

vim.keymap.set(
  "v",
  "<C-i>", -- or <Tab>
  ">gv",
  { desc = "Indent selection" }
)
vim.keymap.set(
  "v",
  "<C-o>", -- because it's next to <C-i> & does nothing in visual mode
  "<gv",
  { desc = "Unindent selection" }
)

vim.keymap.set({ "n", "v" }, "+", '"+', { desc = "System clipboard register" })
vim.keymap.set({ "n", "v" }, "_", '"_', { desc = "Black hole register" })
vim.keymap.set({ "n", "v" }, "Q", "@q", { desc = "Default macro register" })
vim.keymap.set("i", "<C-r>", '<C-r>"', { desc = "Paste from default register" })

vim.keymap.set("n", "<leader>v", vim.diagnostic.open_float, { desc = "[V]iew diagnostic" })

vim.keymap.set("n", "K", actions.hover, { desc = "Hover" })

-- [[ Go-to keymaps ]]

-- Dianostics can be errors, warnings, information messages or hints
vim.keymap.set({ "n", "x", "o" }, "[d", actions.next_diagnostic, { desc = "Next diagnostic" })
vim.keymap.set({ "n", "x", "o" }, "]d", actions.prev_diagnostic, { desc = "Previous diagnostic" })
vim.keymap.set({ "n", "x", "o" }, "[e", actions.next_error, { desc = "Next error" })
vim.keymap.set({ "n", "x", "o" }, "]e", actions.prev_error, { desc = "Previous error" })

vim.keymap.set({ "n", "x", "o" }, "[u", actions.next_url, { desc = "Next URL" })
vim.keymap.set({ "n", "x", "o" }, "]u", actions.prev_url, { desc = "Previous URL" })

-- [[ Terminal-like keymaps ]]
-- Keymaps for insert & command-line modes to reproduce shell keymaps

vim.keymap.set({ "i", "c" }, "<M-BS>", "<C-w>", { desc = "Delete word" })

vim.keymap.set({ "i", "c" }, "<C-b>", "<Left>", { desc = "Move cursor one character left" })
vim.keymap.set({ "i", "c" }, "<C-f>", "<Right>", { desc = "Move cursor one character right" })

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

vim.keymap.set({ "i", "c" }, "<C-e>", "<End>", { desc = "Move cursor to end of line" })
vim.keymap.set({ "i", "c" }, "<C-a>", "<Home>", { desc = "Move cursor to beginning of line" })

-- [[ Terminal emulator keymaps ]]
-- Keymaps for Terminal mode, when in builtin terminal emulator or in ToggleTerm

-- Builtin keymap to exit terminal mode is <C-\\><C-n>, let's simplify it
vim.keymap.set({ "t" }, "<C-\\>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- vim: ts=2 sts=2 sw=2 et
