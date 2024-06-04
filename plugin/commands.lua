-- [[ User commands ]]

--- Clear function for normal mode: clear search highlights, Noice messages, etc.
---@return nil
local function clear_normal()
  -- Clear search highlights in case `vim.o.hlsearch` is true
  vim.cmd("nohlsearch")

  -- Dismiss Noice messages if Noice is loaded
  local noice = package.loaded.noice
  if noice ~= nil then
    noice.cmd("dismiss")
  end
end
vim.api.nvim_create_user_command("ClearNormal", clear_normal, { desc = "Clear for normal mode" })

--- Clear function for insert mode: clear Copilot & nvim-cmp suggestions, etc.
---@return nil
local function clear_insert()
  -- Clear Copilot suggestion
  if package.loaded._copilot ~= nil then
    vim.fn["copilot#Dismiss"]()
  end

  -- Clear nvim-cmp suggestion
  local cmp = package.loaded.cmp
  if cmp ~= nil then
    cmp.abort()
  end
end
vim.api.nvim_create_user_command("ClearInsert", clear_insert, { desc = "Clear for insert mode" })

--- Clear function for all modes: clear normal mode artifacts, insert mode artifacts, etc.
---@return nil
local function clear_all()
  clear_normal()
  clear_insert()
end
vim.api.nvim_create_user_command("ClearAll", clear_all, { desc = "Clear for all modes" })

-- [[ Auto-commands ]]

local augroup = vim.api.nvim_create_augroup("CustomCommands", { clear = true })

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", { callback = function() vim.highlight.on_yank() end, group = augroup })

-- Clear unnamed buffers which are empty (created when no buffer is open)
local function clear_unnamed_buffers()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if
      vim.api.nvim_buf_is_loaded(bufnr)
      and vim.api.nvim_buf_get_name(bufnr) == ""
      and vim.api.nvim_get_option_value("buftype", { buf = bufnr }) == ""
    then
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false) -- Get all lines in the buffer
      local total_characters = 0
      for _, line in ipairs(lines) do
        total_characters = total_characters + #line
      end
      if total_characters == 0 then
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end
    end
  end
end
vim.api.nvim_create_autocmd("BufReadPost", { callback = clear_unnamed_buffers, group = augroup })
