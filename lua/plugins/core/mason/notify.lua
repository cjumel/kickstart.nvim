-- Module directly adapted from mason-lspconfig.notify

local TITLE = "mason.nvim"

--- Send a notification with a format specific to mason.nvim
---@param msg string
---@param level number|nil
---@return nil
local function notify(msg, level)
  level = level or vim.log.levels.INFO
  vim.notify(msg, level, {
    title = TITLE,
  })
end

return notify
