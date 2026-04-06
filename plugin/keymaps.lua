-- [[ Modify builtin keymaps ]]

-- Smart version of `a` & `i` keymaps to automatically indent in empty lines
local function smart_a_or_i(default_keymap)
  if
    vim.bo.buftype ~= "" -- Ignore special buffers (can crash when not modifiable)
    or string.match(vim.api.nvim_get_current_line(), "%g") ~= nil -- Line is not empty
  then
    return default_keymap
  end
  return '"_cc' -- Save to black hole register to avoid polluting the default register
end
vim.keymap.set("n", "a", function() return smart_a_or_i("a") end, { desc = "Append", expr = true, noremap = true })
vim.keymap.set("n", "i", function() return smart_a_or_i("i") end, { desc = "Insert", expr = true, noremap = true })

-- Remap $ in visual mode to avoid selecting the newline character (consistent with other modes)
vim.keymap.set("v", "$", "$h", { desc = "End of line" })

-- Increase the amount of scrolling with <C-e> and <C-y>
vim.keymap.set({ "n", "v" }, "<C-y>", "3<C-y>", { desc = "Scroll up a few lines" })
vim.keymap.set({ "n", "v" }, "<C-e>", "3<C-e>", { desc = "Scroll down a few lines" })

-- [[ Normal mode keymaps ]]

vim.keymap.set("n", "gp", vim.diagnostic.open_float, { desc = "Preview diagnostics" })
vim.keymap.set("n", "gl", vim.diagnostic.reset, { desc = "Reload diagnostics" })

local function clear_normal_mode()
  vim.cmd("nohlsearch")
  local lualine = package.loaded.lualine
  if lualine ~= nil then
    lualine.refresh({ place = { "statusline" } }) -- Immediately refresh the search count component
  end
  local noice = package.loaded.noice
  if noice ~= nil then
    noice.cmd("dismiss")
  end
end
vim.keymap.set("n", "<Esc>", clear_normal_mode, { desc = "Clear" })

vim.keymap.set({ "n", "v" }, "_", '"_', { desc = "Black hole register" })
vim.keymap.set({ "n", "v" }, "+", '"+', { desc = "System clipboard register" })

local buffer_changes = "<cmd>vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis<CR>"
vim.keymap.set("n", "<leader>vb", buffer_changes, { desc = "[V]iew: [B]uffer changes" })

local function send_to_clipboard()
  local yanked = vim.fn.getreg('"')
  vim.fn.setreg("+", yanked)
  local lines = vim.split(yanked, "\n", { plain = true })
  local message
  if #lines == 1 then
    message = "Last yanked sent to clipboard:\n```" .. yanked .. "```"
  else
    if #lines - 1 == 1 then
      message = "Last yanked sent to clipboard (" .. tostring(#lines - 1) .. " line)"
    else
      message = "Last yanked sent to clipboard (" .. tostring(#lines - 1) .. " lines)"
    end
  end
  vim.notify(message, vim.log.levels.INFO, { title = "Yank" })
end
vim.keymap.set("n", "gy", send_to_clipboard, { desc = "Send yanked to clipboard" })

---@class YankPathOpts
---@field line? boolean

---@param opts YankPathOpts?
local function yank_path(opts)
  opts = opts or {}
  local line = opts.line or false
  local register = vim.v.register
  local path = nil
  if vim.bo.buftype == "" then -- Regular buffer
    path = vim.fn.expand("%")
  elseif vim.bo.filetype == "oil" then
    local oil = require("oil")
    path = oil.get_current_dir()
    if path ~= nil then
      path = path:gsub("/$", "") -- Remove the "/" suffix if it exists (necessary to get the tail with `mods`)
    end
  end
  if path ~= nil then
    path = vim.fn.fnamemodify(path, ":~:.")
    if path:find("%s") and vim.fn.confirm("White spaces found in path, escape them?", "&Yes\n&No") == 1 then
      path = path:gsub(" ", "\\ ")
    end
    if line then
      path = path .. ":" .. vim.fn.line(".")
    end
    vim.fn.setreg(register, path)
    vim.notify(
      "Yanked to register `" .. register .. "`:\n```\n" .. path .. "\n```",
      vim.log.levels.INFO,
      { title = "Yank" }
    )
  end
end
vim.keymap.set("n", "<leader>yp", function() yank_path() end, { desc = "[Y]ank: [P]ath" })
vim.keymap.set("n", "<leader>yl", function() yank_path({ line = true }) end, { desc = "[Y]ank: [L]ine position" })

local function next_error() vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = 1 }) end
local function prev_error() vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = -1 }) end
vim.keymap.set("n", "]e", next_error, { desc = "Jump to the next error in the current buffer" })
vim.keymap.set("n", "[e", prev_error, { desc = "Jump to the previous error in the current buffer" })

-- [[ Insert and command-line keymaps ]]

local function tab_improved()
  local copilot_suggestion = package.loaded["copilot.suggestion"]
  if copilot_suggestion ~= nil and copilot_suggestion.is_visible() then
    copilot_suggestion.accept()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
  end
end

-- General keymaps
vim.keymap.set("i", "<Tab>", tab_improved, { desc = "Insert tab or accept Copilot suggestion" })
vim.keymap.set({ "i", "c" }, "<C-w>", "<C-S-w>", { desc = "Delete word" }) -- Make it also work in special buffers
vim.keymap.set({ "i", "c" }, "<C-r><C-r>", '<C-r>"', { desc = "Paste from main register" })

local function right_improved()
  if vim.fn.mode() == "c" and vim.fn.getcmdpos() > #vim.fn.getcmdline() then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-f>", true, false, true), "n", false)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Right>", true, false, true), "n", false)
  end
end
local function c_right_improved()
  local copilot_suggestion = package.loaded["copilot.suggestion"]
  if copilot_suggestion ~= nil and copilot_suggestion.is_visible() then
    copilot_suggestion.accept_word()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-Right>", true, false, true), "n", false)
  end
end
local function end_improved()
  local copilot_suggestion = package.loaded["copilot.suggestion"]
  if copilot_suggestion ~= nil and copilot_suggestion.is_visible() then
    copilot_suggestion.accept_line()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<End>", true, false, true), "n", false)
  end
end

-- Emacs-style navigation keymaps augmented with Copilot suggestion acceptance
vim.keymap.set({ "i", "c" }, "<C-f>", right_improved, { desc = "Move cursor one character right or commanline window" })
vim.keymap.set({ "i", "c" }, "<C-b>", "<Left>", { desc = "Move cursor one character left" })
vim.keymap.set({ "i", "c" }, "<M-f>", c_right_improved, { desc = "Move cursor one word right or accept Copilot word" })
vim.keymap.set({ "i", "c" }, "<M-b>", "<C-Left>", { desc = "Move cursor one word left" })
vim.keymap.set({ "i", "c" }, "<C-e>", end_improved, { desc = "Move cursor to end of line or accept Copilot line" })
vim.keymap.set({ "i", "c" }, "<C-a>", "<Home>", { desc = "Move cursor to beginning of line" })
vim.keymap.set("i", "<C-n>", "<Down>", { desc = "Move cursor down" })
vim.keymap.set("i", "<C-p>", "<Up>", { desc = "Move cursor up" })

-- Disable builtin command-line completion
vim.keymap.set("c", "<Tab>", "<Nop>", { silent = true })
vim.keymap.set("c", "<S-Tab>", "<Nop>", { silent = true })
vim.keymap.set("c", "<C-d>", "<Nop>", { silent = true })
