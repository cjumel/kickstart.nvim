local utils = require("utils")

local M = {}

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

-- Display the Harpoon list key corresponding to the current buffer, if any
-- This will lazy-load Harpoon as soon as a buffer is opened
local harpoon_default_symbol = "󰟢" -- Displayed when not in Harpoon list
local harpoon_symbols = { -- `harpoon_symbols[idx]` is displayed when buffer is Harpoon's list idx'th buffer
  "[J]",
  "[K]",
  "[L]",
  "[M]",
  "[,]",
  "[;]",
  "[:]",
  "[=]",
}
local harpoon_out_of_bound_symbol = "++" -- Displayed when the buffer index doesn't correspond to a supported key
M.harpoon = {
  function()
    local path = utils.path.get_current_buffer_path()
    if path == nil then -- No buffer is opened
      return harpoon_default_symbol
    end

    local harpoon = require("harpoon") -- Harpoon is not loaded if no buffer/directory is opened
    local harpoon_list_length = harpoon:list():length()
    for index = 1, harpoon_list_length do
      local harpoon_file_path = harpoon:list():get(index).value
      if path == harpoon_file_path then
        local harpoon_symbol = harpoon_symbols[index]
        if harpoon_symbol == nil then -- The index is above the number of defined symbols & keys
          return harpoon_out_of_bound_symbol
        end
        return harpoon_symbol
      end
    end

    return harpoon_default_symbol
  end,
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
