--- Clear window artifacts, like highlights or floating windows.
---@return nil
local function clear_window()
  vim.cmd("nohlsearch") -- Clear search highlights in case `vim.o.hlsearch` is true

  -- Dismiss Noice messages if Noice is loaded
  local noice = package.loaded.noice
  if noice ~= nil then
    noice.cmd("dismiss")
  end

  -- If zen-mode is loaded, fetch its window ids to avoid closing them
  local zen_mode = package.loaded["zen-mode"]
  local zen_mode_win = nil -- Main window
  local zen_mode_bg_win = nil -- Background window
  if zen_mode ~= nil then
    local zen_mode_view = require("zen-mode.view")
    if zen_mode_view.is_open() then
      zen_mode_win = zen_mode_view.win
      zen_mode_bg_win = zen_mode_view.bg_win
    end
  end

  -- Clear remaining relative windows (e.g. preview or hover floating windows) except the zen-mode windows
  for _, id in ipairs(vim.api.nvim_list_wins()) do
    local ok, win_config = pcall(vim.api.nvim_win_get_config, id) -- Handle cases of invalid window ids
    if ok and win_config.relative ~= "" and id ~= zen_mode_win and id ~= zen_mode_bg_win then
      vim.api.nvim_win_close(id, false)
    end
  end
end
vim.api.nvim_create_user_command("ClearWindow", clear_window, { desc = "Clear window artifacts" })

--- Clear insert mode artifacts, like copilot or nvim-cmp suggestions.
---@return nil
local function clear_insert_mode()
  -- Dismiss Copilot suggestion
  if package.loaded._copilot ~= nil then
    vim.fn["copilot#Dismiss"]()
  end

  -- Dismiss nvim-cmp suggestion
  local cmp = package.loaded.cmp
  if cmp ~= nil then
    cmp.abort()
  end
end
vim.api.nvim_create_user_command("ClearInsertMode", clear_insert_mode, { desc = "Clear insert mode artifacts" })

--- Clear all artifacts, like highlights, floating windows, copilot or nvim-cmp suggestions.
---@return nil
local function clear_all()
  clear_window()
  clear_insert_mode()
end
vim.api.nvim_create_user_command("ClearAll", clear_all, { desc = "Clear all artifacts" })
