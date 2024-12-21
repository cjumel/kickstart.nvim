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

vim.keymap.set("n", "<leader><CR>", function() vim.cmd("w") end, { desc = "Write buffer" })
vim.keymap.set("n", "<leader>!", vim.diagnostic.open_float, { desc = "Expand diagnostics" })
vim.keymap.set({ "n", "v" }, "<C-^>", "}", { desc = "Next paragraph" }) -- <C-,>
vim.keymap.set({ "n", "v" }, "<C-_>", "{", { desc = "Previous paragraph" }) -- <C-;>

--- Clear normal-mode artifacts, like Noice notifications. This will close the Noice command-line popup if it's open,
--- so this should not be used in command-line mode when using Noice.
---@return nil
local function clear_normal_mode_artifacts()
  -- Clear search highlights in case `vim.o.hlsearch` is true
  vim.cmd("nohlsearch")

  -- Clear Noice messages
  if package.loaded.noice ~= nil then
    require("noice").cmd("dismiss")
  end
end

--- Clear insert-mode artifacts, like nvim-cmp completion suggestions.
---@return nil
local function clear_insert_mode_artifacts()
  -- Clear nvim-cmp suggestion
  if package.loaded.cmp ~= nil then
    require("cmp").abort()
  end

  -- Clear copilot.lua suggestion
  if package.loaded.copilot ~= nil then
    if require("copilot.suggestion").is_visible() then
      require("copilot.suggestion").dismiss()
    end
  end
end

vim.keymap.set("n", "<Esc>", clear_normal_mode_artifacts, { desc = "Clear" }) -- <Esc> is only available in normal mode
vim.keymap.set({ "n", "v" }, "<C-c>", clear_normal_mode_artifacts, { desc = "Clear" })
vim.keymap.set({ "i", "c" }, "<C-c>", clear_insert_mode_artifacts, { desc = "Clear" })

vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent selection" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Unindent selection" })

--- Fetch the path of the file or directory linked to the current buffer (must be a regular buffer or an Oil buffer),
--- apply the provided modifiers to it and yank it to the default register.
---@return nil
local function yank_path(mods)
  local path = nil
  if vim.bo.buftype == "" then -- Regular buffer
    path = vim.fn.expand("%")
  elseif vim.bo.filetype == "oil" then -- Oil buffer
    local oil = require("oil")
    path = oil.get_current_dir()
    if path ~= nil then
      path = path:gsub("/$", "") -- Remove the "/" prefix if it exists (necessary to get the tail with `mods`)
    end
  end

  if path ~= nil then
    path = vim.fn.fnamemodify(path, mods)
    vim.fn.setreg('"', path)
    vim.notify('Yanked "' .. path .. '"')
  end
end

--- Send yanked to the system clipboard.
---@return nil
local function yank_send_to_clipboard()
  local content = vim.fn.getreg('"')
  vim.fn.setreg("+", content)
  vim.notify('Sent "' .. content .. '" to system clipboard')
end

--- Receive yanked from the system clipboard.
---@return nil
local function yank_receive_from_clipboard()
  local content = vim.fn.getreg("+")
  vim.fn.setreg('"', content)
  vim.notify('Received "' .. content .. '" from system clipboard')
end

vim.keymap.set({ "n", "v" }, "_", '"_', { desc = "Black hole register" })
vim.keymap.set({ "n", "v" }, "+", '"+', { desc = "System clipboard register" })

vim.keymap.set("n", "<leader>yp", function() yank_path(":~:.") end, { desc = "[Y]ank: [P]ath" })
vim.keymap.set("n", "<leader>ya", function() yank_path(":p") end, { desc = "[Y]ank: [A]bsolute path" })
vim.keymap.set("n", "<leader>yn", function() yank_path(":t") end, { desc = "[Y]ank: [N]ame" })
vim.keymap.set("n", "<leader>ys", yank_send_to_clipboard, { desc = "[Y]ank: [S]end to clipboard" })
vim.keymap.set("n", "<leader>yr", yank_receive_from_clipboard, { desc = "[Y]ank: [R]eceive from clipboard" })

-- Complete "gx" (open entry under the cursor or selection with external tool, in normal or visual mode) with:
--  - "gX" to open the current file with external tool, in normal mode
--  - "gb" to search the word under the cursor or the selection in a browser, in normal or visual mode
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
    if input == nil or input == "" then
      return
    end

    -- Replace white spaces in the search text with "+" to form a valid search URL
    local tokens = {}
    for token in string.gmatch(input, "%S+") do
      table.insert(tokens, token)
    end
    local search_text = table.concat(tokens, "+")
    vim.ui.open("https://www.google.com/search?q=" .. search_text)
  end)
end
vim.keymap.set({ "n", "v" }, "gb", search_in_web_browser, { desc = "Search word under the cursor in Web browser" })

-- [[ Insert and command-line keymaps ]]
-- Keymaps for insert and command-line modes, notably reproducing some shell keymaps

vim.keymap.set({ "i", "c" }, "<M-BS>", "<C-w>", { desc = "Delete word" }) -- <C-BS>

-- Define functions to mix insert-mode navigation and accepting Copilot.lua suggestions, just like how the
-- zsh-autosuggestions plugin handles the similar situation in Zsh (except for <C-f>, as in Neovim it remains useful to
-- move the cursor while Copilot suggestion is visible)
local function tab_improved()
  if package.loaded.copilot ~= nil and require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
  end
end
local function c_right_improved()
  if package.loaded.copilot ~= nil and require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept_word()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-Right>", true, false, true), "n", false)
  end
end
local c_right_improved_desc = "Accept word in Copilot suggestion or move cursor to next word"
local function end_improved()
  if package.loaded.copilot ~= nil and require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept_line()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<End>", true, false, true), "n", false)
  end
end
local end_improved_desc = "Accept line in Copilot suggestion or move cursor to end of line"

vim.keymap.set("i", "<Tab>", tab_improved, { desc = "Accept Copilot suggestion or insert Tab" })

vim.keymap.set({ "i", "c" }, "<C-f>", "<Right>", { desc = "Move cursor one character right" })
vim.keymap.set({ "i", "c" }, "<C-b>", "<Left>", { desc = "Move cursor one character left" })

vim.keymap.set("i", "<C-^>", c_right_improved, { desc = c_right_improved_desc }) -- <C-,>
vim.keymap.set("c", "<C-^>", "<C-Right>", { desc = "Move cursor to next word" }) -- <C-,>
vim.keymap.set({ "i", "c" }, "<C-_>", "<C-Left>", { desc = "Move cursor to previous word" }) -- <C-;>

vim.keymap.set("i", "<C-e>", end_improved, { desc = end_improved_desc })
vim.keymap.set("c", "<C-e>", "<End>", { desc = "Move cursor to end of line" })
vim.keymap.set({ "i", "c" }, "<C-a>", "<Home>", { desc = "Move cursor to beginning of line" })

vim.keymap.set("c", "<C-d>", "<C-c>", { desc = "Exit cmdline" })

-- Disable builtin auto-completion in command-line mode, to avoid triggering it by mistake
vim.keymap.set("c", "<Tab>", "<Nop>", { silent = true })
vim.keymap.set("c", "<S-Tab>", "<Nop>", { silent = true })

-- [[ Terminal keymaps ]]
-- Keymaps for terminal mode, when using the builtin terminal emulator or toggleterm.nvim for instance

-- Builtin keymap to exit terminal mode is <C-\\><C-n>, let's simplify it
vim.keymap.set({ "t" }, "<C-\\>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
