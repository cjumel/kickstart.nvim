-- [[ Modify builtin keymaps ]]

-- Remap j/k to deal with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Remap gg/G to go to buffer beginning/end instead of first/last line
vim.keymap.set({ "n", "o", "x" }, "gg", "gg0", { desc = "Beginning buffer" })
vim.keymap.set({ "n", "o", "x" }, "G", "G$", { desc = "End of buffer" })

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

-- Remap arrow keys to scrolling (convenient to use only one hand to browse a file)
vim.keymap.set("n", "<Left>", "<C-u>", { desc = "Scroll up half a sreen" })
vim.keymap.set("n", "<Right>", "<C-d>", { desc = "Scroll down half a sreen" })
vim.keymap.set("n", "<Up>", "3<C-y>", { desc = "Scroll up a few lines" })
vim.keymap.set("n", "<Down>", "3<C-e>", { desc = "Scroll down a few lines" })

-- [[ General keymaps ]]

vim.keymap.set({ "n", "x" }, "(", "<", { desc = "Indent left" })
vim.keymap.set({ "n", "x" }, ")", ">", { desc = "Indent right" })

vim.keymap.set({ "n", "v" }, "<C-^>", "}", { desc = "Next paragraph" }) -- <C-,>
vim.keymap.set({ "n", "v" }, "<C-_>", "{", { desc = "Previous paragraph" }) -- <C-;>

local function clear_normal_mode()
  vim.cmd("nohlsearch") -- Clear search highlights in case `vim.o.hlsearch` is true
  if package.loaded.noice ~= nil then
    require("noice").cmd("dismiss") -- Clear Noice messages
  end
end
local function clear_inser_mode()
  if package.loaded.noice ~= nil then
    require("noice").cmd("dismiss") -- Clear Noice messages (especially useful for LSP signature)
  end
  if package.loaded.cmp ~= nil then
    require("cmp").abort() -- Clear nvim-cmp suggestion
  end
end
local function clear_commandline_mode()
  if package.loaded.cmp ~= nil then
    require("cmp").abort() -- Clear nvim-cmp suggestion
  end
end
vim.keymap.set("n", "<Esc>", clear_normal_mode, { desc = "Clear" })
vim.keymap.set("i", "<C-c>", clear_inser_mode, { desc = "Clear" })
vim.keymap.set("c", "<C-c>", clear_commandline_mode, { desc = "Clear" })

vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent selection" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Unindent selection" })

vim.keymap.set({ "n", "v" }, "_", '"_', { desc = "Black hole register" })
vim.keymap.set({ "n", "v" }, "+", '"+', { desc = "System clipboard register" })

vim.keymap.set("n", "<leader><CR>", "<cmd>w<CR>", { desc = "Write buffer" })
vim.keymap.set("n", "<leader><S-CR>", "<cmd>noautocmd w<CR>", { desc = "Write buffer without auto-commands" })
vim.keymap.set("n", "<leader><M-CR>", "<cmd>noautocmd w!<CR>", { desc = "Force write buffer without auto-commands" })

local function send_to_clipboard()
  local yanked = vim.fn.getreg('"')
  vim.fn.setreg("+", yanked)
  vim.notify("Yanked sent to register `+`:\n```\n" .. yanked .. "\n```")
end
local function toggle_sync_with_clipboard()
  if not vim.tbl_contains(vim.opt.clipboard, "unnamedplus") then
    vim.opt.clipboard:append("unnamedplus")
    vim.notify("Register and clipboard sync enabled")
  else
    vim.opt.clipboard:remove("unnamedplus")
    vim.notify("Register and clipboard sync disabled")
  end
end
vim.keymap.set("n", "gy", send_to_clipboard, { desc = "Send yanked to clipboard" })
vim.keymap.set("n", 'g"', toggle_sync_with_clipboard, { desc = "Toggle register and clipboard sync" })

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
    vim.notify('Yanked to register `"`:\n```\n' .. path .. "\n```")
  end
end
vim.keymap.set("n", "<leader>yp", function() yank_file_path(":~:.") end, { desc = "[Y]ank: file [P]ath" })
vim.keymap.set("n", "<leader>ya", function() yank_file_path(":~") end, { desc = "[Y]ank: [A]bsolute file path" })
vim.keymap.set("n", "<leader>yn", function() yank_file_path(":t") end, { desc = "[Y]ank: file [N]ame" })

local function yank_buffer_contents()
  local lines = {}
  local bufcount = 0
  local linecount = 0
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if
      vim.api.nvim_buf_is_valid(bufnr)
      and vim.api.nvim_buf_is_loaded(bufnr)
      and vim.api.nvim_buf_get_name(bufnr) ~= ""
      and vim.api.nvim_get_option_value("buftype", { buf = bufnr }) == ""
    then
      local bufpath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p:~:.")
      if not bufpath:match("^~/.nvim%-scratch/") then
        local buflines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        vim.list_extend(lines, { "File `" .. bufpath .. "`:", "```" .. vim.bo[bufnr].filetype })
        vim.list_extend(lines, buflines)
        vim.list_extend(lines, { "```", "" })
        bufcount = bufcount + 1
        linecount = linecount + #buflines
      end
    end
  end
  local content = table.concat(lines, "\n")
  vim.fn.setreg("+", content)
  vim.notify("Yanked buffer contents to register `+` (" .. bufcount .. " buffers, " .. linecount .. " lines)")
end
vim.keymap.set("n", "<leader>yb", yank_buffer_contents, { desc = "[Y]ank: [B]uffer contents" })

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

vim.keymap.set({ "i", "c" }, "<M-BS>", "<C-w>", { desc = "Delete word" }) -- For consistency with zsh & other softwares
vim.keymap.set({ "i", "c" }, "<C-r><C-r>", '<C-r>"', { desc = "Paste from main register" })

-- Define functions to mix insert-mode navigation and accepting Copilot.lua suggestions, just like how the zsh
-- zsh-autosuggestions plugin does it (except for <C-f>, which remains useful in Neovim in this context)
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

vim.keymap.set({ "i", "c" }, "<C-]>", "<Up>", { desc = "Up or previous item in history" }) -- <C-$>
vim.keymap.set({ "i", "c" }, "<C-\\>", "<Down>", { desc = "Down or next item in history" }) -- <C-`>

-- Disable builtin command-line mode auto-completion keymaps
vim.keymap.set("c", "<Tab>", "<Nop>", { silent = true })
vim.keymap.set("c", "<S-Tab>", "<Nop>", { silent = true })
vim.keymap.set("c", "<C-d>", "<Nop>", { silent = true })
