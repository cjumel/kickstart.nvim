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

-- Show the index & name of the ToggleTerm opened in a window instead of the ToggleTerm buffer path
M.toggleterm = {
  function()
    local terms = require("toggleterm.terminal")
    local term = terms.get(vim.b.toggle_number)
    if term == nil then
      return ""
    end
    return "Terminal " .. term.id .. ": " .. term:_display_name()
  end,
}

return M
