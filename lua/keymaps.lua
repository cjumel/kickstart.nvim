-- Define general custom keymaps.

local actions = require("actions")
local utils = require("utils")

-- [[ Disable builtin keymaps ]]
-- Disable builtin keymaps that are not useful or that are conflicting with custom keymaps.

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

-- [[ Redefine builtin keymaps ]]
-- These keymaps fix or alter the behavior of builtin keymaps.

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

-- [[ General keymaps ]]
-- Define new general keymaps, sometimes involving multiple plugins.

vim.keymap.set("n", "<Esc>", actions.clear_window, { desc = "Clear window" })
-- In visual, insert & cmdline modes, <ESC> is already taken, so let's use <C-c> instead
vim.keymap.set({ "i", "v", "c" }, "<C-c>", function()
  if vim.fn.mode() == "i" then
    actions.clear_all()
  elseif vim.fn.mode() == "v" then
    actions.clear_window() -- Cleaning insert mode stuff is useless in visual mode
  elseif vim.fn.mode() == "c" then
    actions.clear_insert_mode() -- Don't clean window stuff to avoid closing the cmdline itself
  end
end, { desc = "Clear window" })

-- Naturally use <C-i> to indent, & <C-o> because it's next to <C-i> & does nothing in visual mode
vim.keymap.set("v", "<C-i>", ">gv", { desc = "Indent selection" })
vim.keymap.set("v", "<C-o>", "<gv", { desc = "Unindent selection" })

-- Shortcuts for quicker access to some of the main registers
vim.keymap.set({ "n", "v" }, "+", '"+', { desc = "System clipboard register" })
vim.keymap.set({ "n", "v" }, "_", '"_', { desc = "Black hole register" })
vim.keymap.set({ "n", "v" }, "Q", "@q", { desc = "Run macro from default register" })

vim.keymap.set("n", "<leader><CR>", vim.diagnostic.open_float, { desc = "Open diagnostics" })

vim.keymap.set("n", "<leader>ax", function() vim.cmd("bufdo bd") end, { desc = "[A]ctions: close all buffers" })

vim.keymap.set("n", "<leader>yc", actions.yank.cwd, { desc = "[Y]ank: [C]wd" })
vim.keymap.set("n", "<leader>yr", actions.yank.relative_path, { desc = "[Y]ank: [R]elative path" })
vim.keymap.set("n", "<leader>ya", actions.yank.absolute_path, { desc = "[Y]ank: [A]bsolute path" })
vim.keymap.set("n", "<leader>ys", actions.yank.send_to_clipboard, { desc = "[Y]ank: [S]end to clipboard" })

-- [[ Next/previous keymaps ]]
-- Keymaps to move the cursor to specific locations.

utils.keymap.set_move_pair(
  { "[s", "]s" },
  { function() vim.cmd("normal )") end, function() vim.cmd("normal (") end },
  { { desc = "Next sentence" }, { desc = "Previous sentence" } }
)
utils.keymap.set_move_pair(
  { "[p", "]p" },
  { function() vim.cmd("normal }") end, function() vim.cmd("normal {") end },
  { { desc = "Next paragraph" }, { desc = "Previous paragraph" } }
)

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

-- [[ Terminal-like keymaps ]]
-- Keymaps for insert & command-line modes to reproduce shell keymaps.

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
