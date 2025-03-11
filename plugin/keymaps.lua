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

-- Increase the amount of scrolling with <C-e> and <C-y>
vim.keymap.set({ "n", "v" }, "<C-y>", "3<C-y>", { desc = "Scroll up a few lines" })
vim.keymap.set({ "n", "v" }, "<C-e>", "3<C-e>", { desc = "Scroll down a few lines" })

-- Remap arrow keys to be able to scroll with only one hand on the keyboard
vim.keymap.set("n", "<Left>", "<C-u>", { desc = "Scroll up half a sreen" })
vim.keymap.set("n", "<Right>", "<C-d>", { desc = "Scroll down half a sreen" })
vim.keymap.set("n", "<Up>", "3<C-y>", { desc = "Scroll up a few lines" })
vim.keymap.set("n", "<Down>", "3<C-e>", { desc = "Scroll down a few lines" })

-- [[ General keymaps ]]

vim.keymap.set("n", "<leader><CR>", "<Cmd>w<CR>", { desc = "Write buffer" })
vim.keymap.set("n", "<leader><S-CR>", "<Cmd>noautocmd w<CR>", { desc = "Write buffer without auto-commands" })
vim.keymap.set("n", "<leader><M-CR>", "<Cmd>noautocmd w!<CR>", { desc = "Force write buffer without auto-commands" })
vim.keymap.set("n", "<leader>p", vim.diagnostic.open_float, { desc = "[P]review diagnostics" })
vim.keymap.set(
  "n",
  "<leader>?",
  "<cmd>vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis<CR>",
  { desc = "Show buffer changes" }
)

-- Make indent right/left easier to type (overriding next/previous sentence)
vim.keymap.set({ "n", "x" }, "(", "<", { desc = "Indent left" })
vim.keymap.set({ "n", "x" }, ")", ">", { desc = "Indent right" })

vim.keymap.set({ "n", "v" }, "<C-^>", "}", { desc = "Next paragraph" }) -- <C-,>
vim.keymap.set({ "n", "v" }, "<C-_>", "{", { desc = "Previous paragraph" }) -- <C-;>

vim.keymap.set("n", "<Esc>", function()
  vim.cmd("nohlsearch") -- Clear search highlights in case `vim.o.hlsearch` is true
  if package.loaded.noice ~= nil then
    require("noice").cmd("dismiss") -- Clear Noice messages
  end
end, { desc = "Clear" })
vim.keymap.set("i", "<C-c>", function()
  if package.loaded.noice ~= nil then
    require("noice").cmd("dismiss") -- Clear Noice messages (especially useful for LSP signature)
  end
  if package.loaded.cmp ~= nil then
    require("cmp").abort() -- Clear nvim-cmp suggestion
  end
end, { desc = "Clear" })
vim.keymap.set("c", "<C-c>", function()
  if package.loaded.cmp ~= nil then
    require("cmp").abort() -- Clear nvim-cmp suggestion
  end
end, { desc = "Clear" })

vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent selection" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Unindent selection" })

vim.keymap.set({ "n", "v" }, "_", '"_', { desc = "Black hole register" })
vim.keymap.set({ "n", "v" }, "+", '"+', { desc = "System clipboard register" })

vim.keymap.set("n", "<leader>ys", function()
  local yanked = vim.fn.getreg('"')
  vim.fn.setreg("+", yanked)
  vim.notify("Yanked to register `+`:\n```\n" .. yanked .. "\n```")
end, { desc = "[Y]ank: [S]end yanked to system clipboard" })
vim.keymap.set("n", "<leader>yt", function()
  if not vim.tbl_contains(vim.opt.clipboard, "unnamedplus") then
    vim.opt.clipboard:append("unnamedplus")
    vim.notify("System clipboard synchronization enabled")
  else
    vim.opt.clipboard:remove("unnamedplus")
    vim.notify("System clipboard synchronization disabled")
  end
end, { desc = "[Y]ank: [T]oggle system clipboard synchronization" })
vim.keymap.set("n", "<leader>yn", function()
  local notification_history = Snacks.notifier.get_history({ reverse = true })
  local notification = notification_history[vim.v.count1].msg
  vim.fn.setreg('"', notification)
  vim.notify('Yanked to register `"`:\n```\n' .. notification .. "\n```")
end, { desc = "[Y]ank: [N]otification" })

--- Fetch the path of the file or directory linked to the current buffer (must be a regular buffer or an Oil buffer),
--- apply the provided modifiers to it and yank it to the default register.
---@return nil
local function yank_file_path(mods)
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

vim.keymap.set("n", "<leader>yfp", function() yank_file_path(":~:.") end, { desc = "[Y]ank [F]ile: [P]ath" })
vim.keymap.set("n", "<leader>yfa", function() yank_file_path(":~") end, { desc = "[Y]ank [F]ile: [A]bsolute path" })
vim.keymap.set("n", "<leader>yfn", function() yank_file_path(":t") end, { desc = "[Y]ank [F]ile: [N]ame" })

-- Like "gx", bur for the current file instead of the link under the cursor
vim.keymap.set(
  "n",
  "gX",
  function() vim.ui.open(vim.fn.expand("%")) end,
  { desc = "Open current file with file system handler" }
)

-- Introduce a browser search keymap with "gb", to launch a simple Web search
local function browser_search()
  local visual_mode = require("visual_mode")
  local default_text = visual_mode.is_on() and visual_mode.get_text() or nil
  vim.ui.input({ prompt = "Web search", default = default_text }, function(input)
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
vim.keymap.set({ "n", "v" }, "gb", browser_search, { desc = "Search in Web browser" })

-- [[ Insert and command-line keymaps ]]
-- Keymaps for insert and command-line modes, notably reproducing some zsh keymaps

-- Make <M-BS> delete word, like in zsh and most some popular applications
vim.keymap.set({ "i", "c" }, "<M-BS>", "<C-w>", { desc = "Delete word" })

-- Define alternative keymaps to up & down arrow keys, useful to change line or cycle the command history
vim.keymap.set({ "i", "c" }, "<C-]>", "<Up>", { desc = "Up" }) -- <C-$>
vim.keymap.set({ "i", "c" }, "<C-\\>", "<Down>", { desc = "Down" }) -- <C-`>

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
  if vim.fn.mode() == "i" and package.loaded.copilot ~= nil and require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept_word()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-Right>", true, false, true), "n", false)
  end
end
local function end_improved()
  if vim.fn.mode() == "i" and package.loaded.copilot ~= nil and require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept_line()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<End>", true, false, true), "n", false)
  end
end

vim.keymap.set("i", "<Tab>", tab_improved, { desc = "Accept Copilot suggestion or insert Tab" })

vim.keymap.set({ "i", "c" }, "<C-f>", "<Right>", { desc = "Move cursor one character right" })
vim.keymap.set({ "i", "c" }, "<C-b>", "<Left>", { desc = "Move cursor one character left" })

vim.keymap.set({ "i", "c" }, "<C-^>", c_right_improved, { desc = "Move cursor to next word" }) -- <C-,>
vim.keymap.set({ "i", "c" }, "<C-_>", "<C-Left>", { desc = "Move cursor to previous word" }) -- <C-;>

vim.keymap.set({ "i", "c" }, "<C-e>", end_improved, { desc = "Move cursor to end of line" })
vim.keymap.set({ "i", "c" }, "<C-a>", "<Home>", { desc = "Move cursor to beginning of line" })

-- Disable builtin auto-completion in command-line mode, to avoid triggering it by mistake
vim.keymap.set("c", "<Tab>", "<Nop>", { silent = true })
vim.keymap.set("c", "<S-Tab>", "<Nop>", { silent = true })
