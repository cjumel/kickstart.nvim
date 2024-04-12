local actions = require("actions")
local utils = require("utils")

local cmap = utils.keymap.cmap
local imap = utils.keymap.icmap
local nmap = utils.keymap.nmap
local vmap = utils.keymap.vmap

-- [[ Disable builtin keymaps ]]

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Disable builtin auto-completion keymaps (avoid writting letters when calling them)
vim.keymap.set("i", "<C-n>", "<Nop>", { silent = true })
vim.keymap.set("i", "<C-p>", "<Nop>", { silent = true })

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

nmap("<ESC>", actions.clear_window, "Clear window")
-- In visual, insert & cmdline modes, <ESC> is already taken, so let's use <C-c> instead
imap("<C-c>", actions.clear_all, "Clear window")
vmap("<C-c>", actions.clear_window, "Clear window")
cmap("<C-c>", actions.clear_insert_mode, "Clear window") -- Avoid closing the cmdline itself

-- Naturally use <C-i> (or <Tab>), & <C-o> because it's next to <C-i> & does nothing in visual mode
vim.keymap.set("v", "<C-i>", ">gv", { desc = "Indent selection" })
vim.keymap.set("v", "<C-o>", "<gv", { desc = "Unindent selection" })

-- Shortcuts for quicker access to some of the main registers
vim.keymap.set({ "n", "v" }, "+", '"+', { desc = "System clipboard register" })
vim.keymap.set({ "n", "v" }, "_", '"_', { desc = "Black hole register" })
vim.keymap.set({ "n", "v" }, "Q", "@q", { desc = "Run macro from default register" })

vim.keymap.set("n", "<leader>p", vim.diagnostic.open_float, { desc = "[P]review diagnostic" })

vim.keymap.set("n", "K", actions.hover, { desc = "Hover" })

-- [[ Go-to keymaps ]]

-- Dianostics can be errors, warnings, information messages or hints
utils.keymap.set_move_pair(
  { "[d", "]d" },
  { vim.diagnostic.goto_next, vim.diagnostic.goto_prev },
  { { desc = "Next diagnostic" }, { desc = "Previous diagnostic" } }
)
utils.keymap.set_move_pair({ "[e", "]e" }, {
  function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end,
  function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end,
}, { { desc = "Next error" }, { desc = "Previous error" } })

-- Conflict markers follow one of the 3 following forms at the start of a line:
-- `<<<<<<< <some text>`, ` =======` or ` >>>>>>> <some text>`
-- "^" forces the search pattern matches to be at the start of a line
local conflict_pattern = "^<<<<<<< \\|^=======\\|^>>>>>>> "
utils.keymap.set_move_pair({ "[=", "]=" }, {
  function() vim.fn.search(conflict_pattern) end,
  function() vim.fn.search(conflict_pattern, "b") end,
}, { { desc = "Next conflict mark" }, { desc = "Previous conflict mark" } })

local url_pattern = "http:\\/\\/\\|https:\\/\\/"
utils.keymap.set_move_pair(
  { "[u", "]u" },
  { function() vim.fn.search(url_pattern) end, function() vim.fn.search(url_pattern, "b") end },
  { { desc = "Next URL" }, { desc = "Previous URL" } }
)

-- [[ Terminal-like keymaps ]]
-- Keymaps for insert & command-line modes to reproduce shell keymaps

vim.keymap.set({ "i", "c" }, "<M-BS>", "<C-w>", { desc = "Delete word" })

vim.keymap.set({ "i", "c" }, "<C-b>", "<Left>", { desc = "Move cursor one character left" })
vim.keymap.set({ "i", "c" }, "<C-f>", "<Right>", { desc = "Move cursor one character right" })

-- <C-^> & <C-_> are actually <C-,> & <C-;> respectively on my keyboard
vim.keymap.set({ "i", "c" }, "<C-^>", "<C-Right>", { desc = "Move cursor to next word" })
vim.keymap.set({ "i", "c" }, "<C-_>", "<C-Left>", { desc = "Move cursor to previous word" })

vim.keymap.set({ "i", "c" }, "<C-e>", "<End>", { desc = "Move cursor to end of line" })
vim.keymap.set({ "i", "c" }, "<C-a>", "<Home>", { desc = "Move cursor to beginning of line" })

-- Use <C-d> in cmdline mode to exit it like in the shell
-- In insert mode, the builtin <C-d> deindents the line so let's not override it
-- For some reason, using `<ESC>` as `rhs` runs the command instead of exiting the cmdline
vim.keymap.set("c", "<C-d>", "<C-c>", { desc = "Exit cmdline" })

-- [[ Terminal emulator keymaps ]]
-- Keymaps for Terminal mode, when in builtin terminal emulator or in ToggleTerm

-- Builtin keymap to exit terminal mode is <C-\\><C-n>, let's simplify it
vim.keymap.set({ "t" }, "<C-\\>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- vim: ts=2 sts=2 sw=2 et
