local utils = require("utils")

-- [[ Disable builtin keymaps ]]
-- Disable some builtin keymaps, because they are useless or they are conflicting with other keymaps

-- Adapt builtin navigation keymaps to inverted "["/"]" and with ","/";" repeating & complete them with missing ones
for _, char in ipairs({ "(", ")", "{", "}", "[", "]", "<", ">" }) do
  utils.keymap.set_move_pair(
    { "[" .. char, "]" .. char },
    { function() vim.fn.search(char) end, function() vim.fn.search(char, "b") end },
    { { desc = "Next " .. char }, { desc = "Previous " .. char } }
  )
end
utils.keymap.set_move_pair(
  { "[b", "]b" },
  { function() vim.fn.search("[()]") end, function() vim.fn.search("[()]", "b") end },
  { { desc = "Next bracket" }, { desc = "Previous bracket" } }
)
utils.keymap.set_move_pair(
  { "[B", "]B" },
  { function() vim.fn.search("[{}]") end, function() vim.fn.search("[{}]", "b") end },
  { { desc = "Next curly bracket" }, { desc = "Previous curly bracket" } }
)

-- [[ Modify builtin keymaps ]]
-- Keymaps to modify (fix or improve) the behavior of builtin keymaps

--- Smart version of `a` & `i` keymaps to automatically indent when used on empty line.
---@param default_keymap string "a" or "i", the action to perform by default.
---@return string
local function smart_a_or_i(default_keymap)
  if
    utils.buffer.is_temporary() -- File type to ignore (crash in not modifiable ones)
    or string.match(vim.api.nvim_get_current_line(), "%g") ~= nil -- Line is not empty
  then
    return default_keymap
  end
  return '"_cc' -- Save to black hole register to avoid polluting the default register
end
vim.keymap.set("n", "a", function() return smart_a_or_i("a") end, { desc = "Append", expr = true, noremap = true })
vim.keymap.set("n", "i", function() return smart_a_or_i("i") end, { desc = "Insert", expr = true, noremap = true })

--- Smart version of `dd` keymap, to avoid saving empty lines in register.
---@return string
local function smart_dd()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd' -- Save to black hole register
  end
  return "dd"
end
vim.keymap.set("n", "dd", smart_dd, { desc = "Line", expr = true, noremap = true })

-- Remap j/k to deal with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Remap gg/G to go to buffer beginning/end instead of first/last line
vim.keymap.set({ "n", "o", "x" }, "gg", "gg0", { desc = "Beginning buffer" })
vim.keymap.set({ "n", "o", "x" }, "G", "G$", { desc = "End of buffer" })

-- Remap $ in visual mode to avoid selecting the newline character (consistent with other modes)
vim.keymap.set("v", "$", "$h", { desc = "End of line" })

-- [[ General keymaps ]]

vim.keymap.set("n", "<leader><CR>", vim.diagnostic.open_float, { desc = "Open diagnostics" })

vim.keymap.set("n", "<Esc>", "<cmd>ClearNormal<CR>", { desc = "Clear" }) -- <Esc> is only available in normal mode
vim.keymap.set("v", "<C-c>", "<cmd>ClearNormal<CR>", { desc = "Clear" })
vim.keymap.set("i", "<C-c>", "<cmd>ClearAll<CR>", { desc = "Clear" })
vim.keymap.set("c", "<C-c>", "<cmd>ClearInsert<CR>", { desc = "Clear" }) -- Don't clean the cmdline popup itself

-- Shortcuts to access the main registers
vim.keymap.set({ "n", "v" }, "+", '"+', { desc = "System clipboard register" })
vim.keymap.set({ "n", "v" }, "_", '"_', { desc = "Black hole register" })

--- Yank the path of the current buffer or directory if in Oil buffer.
---@param opts table|nil Optional parameters. Supported parameters are:
--- - cwd boolean: If true, yank the current working directory. Default is false.
--- - mods string: Modifications to apply to the path. Default is ":~:.".
---@return nil
local function yank_path(opts)
  opts = opts or {}
  local cwd = opts.cwd or false
  local mods = opts.mods or ":~:." -- Relative to cwd or home directory

  local path
  if cwd then
    path = vim.fn.getcwd()
  elseif vim.bo.filetype == "oil" then
    local oil = package.loaded.oil -- Oil should already have been loaded
    path = oil.get_current_dir()
  else
    path = vim.fn.expand("%")
  end

  path = vim.fn.fnamemodify(path, mods)
  vim.fn.setreg('"', path)
  vim.notify('Yanked "' .. path .. '"')
end
vim.keymap.set("n", "<leader>yc", function() yank_path({ cwd = true, mods = ":~" }) end, { desc = "[Y]ank: [C]wd" })
vim.keymap.set("n", "<leader>yr", function() yank_path({ mods = ":~:." }) end, { desc = "[Y]ank: [R]elative path" })
vim.keymap.set("n", "<leader>ya", function() yank_path({ mods = ":~" }) end, { desc = "[Y]ank: [A]bsolute path" })

--- Send the content of the default register to the clipboard.
---@return nil
local function send_yanked_to_clipboard()
  local yank = vim.fn.getreg('"')
  vim.fn.setreg("+", yank)
  vim.notify('Sent "' .. yank .. '" to clipboard')
end
vim.keymap.set("n", "<leader>ys", send_yanked_to_clipboard, { desc = "[Y]ank: [S]end to clipboard" })

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

-- [[ Command-line keymaps ]]
-- Keymaps for command-line mode (also sometimes added to insert mode); these keymaps notably reproduce some shell
-- behaviors in insert and command-line modes

-- Disable builtin auto-completion, to avoid triggering it by mistake
vim.keymap.set("c", "<Tab>", "<Nop>", { silent = true })
vim.keymap.set("c", "<S-Tab>", "<Nop>", { silent = true })

-- In insert mode, the builtin <C-d> deindents the line so let's not override it
-- For some reason, using `<ESC>` as `rhs` runs the command instead of exiting the cmdline
vim.keymap.set("c", "<C-d>", "<C-c>", { desc = "Exit cmdline" })

vim.keymap.set({ "i", "c" }, "<M-BS>", "<C-w>", { desc = "Delete word" }) -- <C-BS>

vim.keymap.set({ "i", "c" }, "<C-b>", "<Left>", { desc = "Move cursor one character left" })
vim.keymap.set({ "i", "c" }, "<C-f>", "<Right>", { desc = "Move cursor one character right" })

vim.keymap.set({ "i", "c" }, "<C-^>", "<C-Right>", { desc = "Move cursor to next word" }) -- <C-,>
vim.keymap.set({ "i", "c" }, "<C-_>", "<C-Left>", { desc = "Move cursor to previous word" }) -- <C-;>

vim.keymap.set({ "i", "c" }, "<C-e>", "<End>", { desc = "Move cursor to end of line" })
vim.keymap.set({ "i", "c" }, "<C-a>", "<Home>", { desc = "Move cursor to beginning of line" })

-- [[ Terminal keymaps ]]
-- Keymaps for terminal mode, when using the builtin terminal emulator or in ToggleTerm, for instance

-- Builtin keymap to exit terminal mode is <C-\\><C-n>, let's simplify it
vim.keymap.set({ "t" }, "<C-\\>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
