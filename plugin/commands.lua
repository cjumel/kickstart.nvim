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
