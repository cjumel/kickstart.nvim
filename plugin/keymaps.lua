local visual_mode = require("visual_mode")

-- [[ Modify builtin keymaps ]]
-- Keymaps to modify (fix or improve) the behavior of builtin keymaps

--- Smart version of `a` & `i` keymaps to automatically indent when used on empty line.
---@param default_keymap string "a" or "i", the action to perform by default.
---@return string
local function smart_a_or_i(default_keymap)
  if
    vim.bo.buftype ~= "" -- Ignore special buffers (can crash when it's not modifiable)
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

vim.keymap.set("n", "<C-]>", vim.diagnostic.open_float, { desc = "Expand diagnostics" }) -- Like preview in plugins
vim.keymap.set({ "n", "v" }, "<C-^>", "}", { desc = "Next paragraph" })
vim.keymap.set({ "n", "v" }, "<C-_>", "{", { desc = "Previous paragraph" })

--- Clear function for normal mode: clear search highlights & Noice messages.
---@return _ nil
local function clear_normal()
  vim.cmd("nohlsearch") -- Clear search highlights in case `vim.o.hlsearch` is true
  local noice = package.loaded.noice
  if noice ~= nil then
    noice.cmd("dismiss") -- Dismiss Noice messages
  end
end

--- Clear function for insert mode: clear Copilot & nvim-cmp suggestions.
---@return _ nil
local function clear_insert()
  if package.loaded._copilot ~= nil then
    vim.fn["copilot#Dismiss"]() -- Clear Copilot suggestion
  end
  local cmp = package.loaded.cmp
  if cmp ~= nil then
    cmp.abort() -- Clear nvim-cmp suggestion
  end
end

--- Clear function for all modes: clear both normal & insert mode artifacts.
---@return _ nil
local function clear_all()
  clear_normal()
  clear_insert()
end

vim.keymap.set("n", "<Esc>", clear_normal, { desc = "Clear" }) -- <Esc> is only available in normal mode
vim.keymap.set("v", "<C-c>", clear_normal, { desc = "Clear" })
vim.keymap.set("i", "<C-c>", clear_all, { desc = "Clear" })
vim.keymap.set("c", "<C-c>", clear_insert, { desc = "Clear" }) -- clean_insert avoids deleting the cmdline popup itself

vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent selection" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Unindent selection" })

--- Yank the path of the current buffer file or directory.
---@return nil
local function yank_path()
  local path
  if vim.bo.filetype == "oil" then
    local oil = package.loaded.oil -- Oil should already have been loaded
    path = oil.get_current_dir()
  else
    path = vim.fn.expand("%")
  end

  path = vim.fn.fnamemodify(path, ":~:.") -- Relative to cwd or home directory with "~" prefix
  vim.fn.setreg('"', path)
  vim.notify('Yanked "' .. path .. '"')
end

--- Send the content of the default register to the clipboard.
---@return nil
local function send_yanked_to_clipboard()
  local yank = vim.fn.getreg('"')
  vim.fn.setreg("+", yank)
  vim.notify('Sent "' .. yank .. '" to clipboard')
end

vim.keymap.set({ "n", "v" }, "+", '"+', { desc = "System clipboard register" })
vim.keymap.set({ "n", "v" }, "_", '"_', { desc = "Black hole register" })
vim.keymap.set("n", "<leader>y", yank_path, { desc = "[Y]ank path" })
vim.keymap.set("n", "<leader>+", send_yanked_to_clipboard, { desc = "Send yanked to clipboard" })

-- Complete "gx" (open entry under the cursor or selection with external tool, in normal or visual mode) with:
--  - "gX" to open the current file with external tool, in normal mode
--  - "g/" to search the word under the cursor or the selection in a browser, in normal or visual mode
vim.keymap.set(
  "n",
  "gX",
  function() vim.ui.open(vim.fn.expand("%")) end,
  { desc = "Open current file with file system handler" }
)
local function search_in_web_browser()
  local text
  if visual_mode.is_on() then
    text = visual_mode.get_text()
  else
    -- Retrieve the search text with the z-register as intermediary, like the smart-gx implementation of
    --  nvim-various-textobjs
    vim.cmd.normal({ '"zyiw', bang = true })
    text = vim.fn.getreg("z")
  end
  vim.ui.input({ prompt = "Web search", default = text }, function(input)
    -- Replace white spaces in the search text with "+" to form a valid search URL
    local tokens = {}
    for token in string.gmatch(input, "%S+") do
      table.insert(tokens, token)
    end
    local search_text = table.concat(tokens, "+")
    vim.ui.open("https://www.google.com/search?q=" .. search_text)
  end)
end
vim.keymap.set({ "n", "v" }, "g/", search_in_web_browser, { desc = "Search word under the cursor in Web browser" })

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
