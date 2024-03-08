local utils = require("utils")

local M = {}

-- Add a message in the status line when recording a macro
-- This means that noice needs to pass the message to the statusline (see noice's wiki)
M.macro = {
  function()
    if package.loaded.noice ~= nil then -- Don't fail if Noice is not setup
      return require("noice").api.statusline.mode.get()
    end
  end,
  cond = function()
    if package.loaded.noice ~= nil then -- Don't fail if Noice is not setup
      return require("noice").api.statusline.mode.has()
    end
  end,
  color = { fg = "#ff9e64" },
}

-- If file or directory (for Oil buffers) is in Harpoon list, show its index
-- This loads Harpoon so it's not lazy-loaded anymore (it's also true for Oil but it's already
-- not lazy loaded)
M.harpoon = {
  function()
    local harpoon = require("harpoon")

    local path = utils.path.get_current_buffer_path()
    if path == nil then
      return ""
    end

    local harpoon_list_length = harpoon:list():length()
    for index = 1, harpoon_list_length do
      local harpoon_file_path = harpoon:list():get(index).value
      if path == harpoon_file_path then
        return "H-" .. index .. "/" .. harpoon_list_length
      end
    end

    return ""
  end,
}

-- Show the path of the directory opened with Oil (instead of Oil's buffer path)
M.oil = {
  function()
    return utils.path.get_current_oil_directory({ cwd_strategy = "absolute" })
  end,
}

-- Show the name of the Trouble window
M.trouble = {
  function()
    local opts = require("trouble.config").options
    local words = vim.split(opts.mode, "[%W]")
    for i, word in ipairs(words) do
      words[i] = word:sub(1, 1):upper() .. word:sub(2)
    end
    return table.concat(words, " ")
  end,
}

-- Show the index of the ToggleTerm
M.toggleterm = {
  function()
    return "ToggleTerm #" .. vim.b.toggle_number
  end,
}

-- Output a fake "utf-8" encoding for a consistent display between some special buffers (like Oil)
-- and regular ones
M.fake_encoding = {
  function()
    return "utf-8"
  end,
}

return M
