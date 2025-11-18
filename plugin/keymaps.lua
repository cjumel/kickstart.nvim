-- [[ Modify builtin keymaps ]]

-- Remap j/k to deal with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Remap gg/G to go to buffer beginning/end instead of first/last line
vim.keymap.set({ "n", "x" }, "gg", "gg0", { desc = "Beginning buffer" })
vim.keymap.set({ "n", "x" }, "G", "G$", { desc = "End of buffer" })

-- Remap $ in visual mode to avoid selecting the newline character (consistent with other modes)
vim.keymap.set("v", "$", "$h", { desc = "End of line" })

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

-- Smart version of `dd` keymap, to avoid yanking empty lines
local function smart_dd()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd' -- Save to black hole register
  end
  return "dd"
end
vim.keymap.set("n", "dd", smart_dd, { desc = "Line", expr = true, noremap = true })

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

vim.keymap.set("n", "<leader><CR>", "<cmd>w<CR>", { desc = "Write buffer" })
vim.keymap.set("n", "<leader><S-CR>", "<cmd>wa<CR>", { desc = "Write all buffers" })
vim.keymap.set("n", "<leader><M-CR>", "<cmd>w!<CR>", { desc = "Force write buffer" })
vim.keymap.set("n", "<leader><C-CR>", "<cmd>noautocmd w<CR>", { desc = "Write buffer without auto-command" })

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

local function yank_file_path(mods)
  local path = nil
  if vim.bo.buftype == "" then -- Regular buffer
    path = vim.fn.expand("%")
  elseif vim.bo.filetype == "oil" then
    local oil = require("oil")
    path = oil.get_current_dir()
    if path ~= nil then
      path = path:gsub("/$", "") -- Remove the "/" prefix if it exists (necessary to get the tail with `mods`)
    end
  end
  if path ~= nil then
    path = vim.fn.fnamemodify(path, mods)
    if path:find("%s") and vim.fn.confirm("White spaces found in path, escape them?", "&Yes\n&No") == 1 then
      path = path:gsub(" ", "\\ ")
    end
    vim.fn.setreg('"', path)
    vim.notify('Yanked to register `"`:\n```\n' .. path .. "\n```", vim.log.levels.INFO, { title = "Yank" })
  end
end
vim.keymap.set("n", "<leader>yp", function() yank_file_path(":~:.") end, { desc = "[Y]ank: file [P]ath" })
vim.keymap.set("n", "<leader>yf", function() yank_file_path(":~") end, { desc = "[Y]ank: [F]ull file path" })
vim.keymap.set("n", "<leader>yn", function() yank_file_path(":t") end, { desc = "[Y]ank: file [N]ame" })

local function yank_buffer_content()
  local bufnr = vim.api.nvim_get_current_buf()
  local buflines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local buffer_content = table.concat(buflines, "\n")
  vim.fn.setreg('"', buffer_content)
  vim.notify(
    "Buffer content (" .. #buflines .. ' lines) yanked to register `"`',
    vim.log.levels.INFO,
    { title = "Yank" }
  )
end
local function yank_all_buffer_contents()
  local lines = {}
  local content_description = ""
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local bufpath = vim.api.nvim_buf_get_name(bufnr)
    if
      vim.api.nvim_buf_is_valid(bufnr)
      and vim.api.nvim_buf_is_loaded(bufnr)
      and bufpath ~= ""
      and vim.api.nvim_get_option_value("buftype", { buf = bufnr }) == ""
    then
      if not bufpath:match("^" .. vim.env.HOME .. "/.local/share/scratch%-files") then
        local buflines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        vim.list_extend(lines, { "File `" .. bufpath .. "`:", "```" .. vim.bo[bufnr].filetype })
        vim.list_extend(lines, buflines)
        vim.list_extend(lines, { "```", "" })
        content_description = content_description .. "\n  - " .. bufpath .. " (" .. #buflines .. " lines)"
      end
    end
  end
  local all_buffer_contents = table.concat(lines, "\n")
  vim.fn.setreg('"', all_buffer_contents)
  vim.notify(
    'All buffer contents yanked to register `"`:' .. content_description,
    vim.log.levels.INFO,
    { title = "Yank" }
  )
end
vim.keymap.set("n", "<leader>yb", yank_buffer_content, { desc = "[Y]ank: [B]uffer content" })
vim.keymap.set("n", "<leader>ya", yank_all_buffer_contents, { desc = "[Y]ank: [A]ll buffer contents" })

-- [[ Navigation keymaps ]]

local keymap = require("config.keymap")

local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move, { desc = "Repeat last move in same direction" })
vim.keymap.set(
  { "n", "x", "o" },
  ",",
  ts_repeat_move.repeat_last_move_opposite,
  { desc = "Repeat last move in opposite direction" }
)

local function next_loclist_item()
  local success = pcall(vim.cmd, "lnext") ---@diagnostic disable-line: param-type-mismatch
  if not success then
    success = pcall(vim.cmd, "lfirst") ---@diagnostic disable-line: param-type-mismatch
    if not success then
      vim.notify("No location list item found", vim.log.levels.WARN, { title = "Navigation" })
    end
  end
end
local function prev_loclist_item()
  local success = pcall(vim.cmd, "lprev") ---@diagnostic disable-line: param-type-mismatch
  if not success then
    success = pcall(vim.cmd, "llast") ---@diagnostic disable-line: param-type-mismatch
    if not success then
      vim.notify("No location list item found", vim.log.levels.WARN, { title = "Navigation" })
    end
  end
end
keymap.set_pair("l", next_loclist_item, prev_loclist_item, "loclist item")
local function next_quickfix_item()
  local success = pcall(vim.cmd, "cnext") ---@diagnostic disable-line: param-type-mismatch
  if not success then
    success = pcall(vim.cmd, "cfirst") ---@diagnostic disable-line: param-type-mismatch
    if not success then
      vim.notify("No quickfix item found", vim.log.levels.WARN, { title = "Navigation" })
    end
  end
end
local function prev_quickfix_item()
  local success = pcall(vim.cmd, "cprev") ---@diagnostic disable-line: param-type-mismatch
  if not success then
    success = pcall(vim.cmd, "clast") ---@diagnostic disable-line: param-type-mismatch
    if not success then
      vim.notify("No quickfix item found", vim.log.levels.WARN, { title = "Navigation" })
    end
  end
end
keymap.set_pair("q", next_quickfix_item, prev_quickfix_item, "quickfix item")

local function next_diagnostic() vim.diagnostic.jump({ count = 1 }) end
local function prev_diagnostic() vim.diagnostic.jump({ count = -1 }) end
keymap.set_pair("d", next_diagnostic, prev_diagnostic, "diagnostic")
local function next_error() vim.diagnostic.jump({ severity = "ERROR", count = 1 }) end
local function prev_error() vim.diagnostic.jump({ severity = "ERROR", count = -1 }) end
keymap.set_pair("e", next_error, prev_error, "error")

local function next_reference() Snacks.words.jump(vim.v.count1, true) end
local function prev_reference() Snacks.words.jump(-vim.v.count1, true) end
keymap.set_pair("]", next_reference, prev_reference, "word reference", "[")

local function next_mark() require("marks").next() end
local function prev_mark() require("marks").prev() end
keymap.set_pair("`", next_mark, prev_mark, "mark")

local function next_hunk()
  require("gitsigns").nav_hunk(
    "next", ---@diagnostic disable-line: param-type-mismatch
    { target = vim.g.gitsigns_all_hunk_navigation and "all" or nil }
  )
end
local function prev_hunk()
  require("gitsigns").nav_hunk(
    "prev", ---@diagnostic disable-line: param-type-mismatch
    { target = vim.g.gitsigns_all_hunk_navigation and "all" or nil }
  )
end
keymap.set_pair("h", next_hunk, prev_hunk, "hunk")

local function next_todo_comment()
  local todo_comment_keywords = require("config.todo-comment-keywords")
  require("todo-comments").jump_next({ keywords = todo_comment_keywords.todo_all })
end
local function prev_todo_comment()
  local todo_comment_keywords = require("config.todo-comment-keywords")
  require("todo-comments").jump_prev({ keywords = todo_comment_keywords.todo_all })
end
keymap.set_pair("t", next_todo_comment, prev_todo_comment, "todo-comment")
local function next_note_comment()
  local todo_comment_keywords = require("config.todo-comment-keywords")
  require("todo-comments").jump_next({ keywords = todo_comment_keywords.note_all })
end
local function prev_note_comment()
  local todo_comment_keywords = require("config.todo-comment-keywords")
  require("todo-comments").jump_prev({ keywords = todo_comment_keywords.note_all })
end
keymap.set_pair("n", next_note_comment, prev_note_comment, "note-comment")
local function next_private_todo_comment()
  local todo_comment_keywords = require("config.todo-comment-keywords")
  require("todo-comments").jump_next({ keywords = todo_comment_keywords.todo_private })
end
local function prev_private_todo_comment()
  local todo_comment_keywords = require("config.todo-comment-keywords")
  require("todo-comments").jump_prev({ keywords = todo_comment_keywords.todo_private })
end
keymap.set_pair("p", next_private_todo_comment, prev_private_todo_comment, "private todo-comment")

local function next_conflict() require("git-conflict").find_next("ours") end
local function prev_conflict() require("git-conflict").find_prev("ours") end
keymap.set_pair("<M-c>", next_conflict, prev_conflict, "conflict")

for _, key in ipairs({ "a", "A", "b", "B", "D", "L", "Q", "T", "<C-l>", "<C-q>", "<C-t>" }) do
  vim.keymap.del("n", "]" .. key)
  vim.keymap.del("n", "[" .. key)
end

-- [[ Insert and command-line keymaps ]]

vim.keymap.set({ "i", "c" }, "<C-w>", "<C-S-w>", { desc = "Delete word" }) -- Make it work also in special buffers
vim.keymap.set({ "i", "c" }, "<C-r><C-r>", '<C-r>"', { desc = "Paste from main register" })

vim.keymap.set({ "i", "c" }, "<C-f>", "<Right>", { desc = "Move cursor one character right" })
vim.keymap.set({ "i", "c" }, "<C-b>", "<Left>", { desc = "Move cursor one character left" })
vim.keymap.set({ "i", "c" }, "<M-f>", "<C-Right>", { desc = "Move cursor to next word" })
vim.keymap.set({ "i", "c" }, "<M-b>", "<C-Left>", { desc = "Move cursor to previous word" })
vim.keymap.set({ "i", "c" }, "<C-e>", "<End>", { desc = "Move cursor to end of line" })
vim.keymap.set({ "i", "c" }, "<C-a>", "<Home>", { desc = "Move cursor to beginning of line" })

vim.keymap.set("c", "<Tab>", "<Nop>", { silent = true })
vim.keymap.set("c", "<S-Tab>", "<Nop>", { silent = true })
vim.keymap.set("c", "<C-d>", "<Nop>", { silent = true })
