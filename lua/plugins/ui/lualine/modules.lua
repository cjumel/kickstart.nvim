local M = {}

M.empty = { function() return "" end }

-- Add a message in the status line when recording a macro
-- Source: https://github.com/folke/noice.nvim/wiki/Configuration-Recipes#show-recording-messages
M.macro = {
  function()
    local noice = package.loaded.noice
    if noice ~= nil then
      return noice.api.statusline.mode.get()
    end
  end,
  cond = function()
    local noice = package.loaded.noice
    if noice ~= nil then
      return noice.api.statusline.mode.has()
    end
  end,
  color = { fg = "#ff9e64" },
}

-- Show the path of the directory opened with Oil instead of Oil's buffer path
M.oil = {
  function()
    local oil = package.loaded.oil
    return vim.fn.fnamemodify(oil.get_current_dir(), ":p:~:.")
  end,
}

return M
