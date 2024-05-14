local utils = require("utils")

local M = {}

-- Add a message in the status line when recording a macro (Noice needs to pass the message, see Noice's wiki)
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

-- If file or directory is in Harpoon list, show its index (this lazy-loads Harpoon as soon as a buffer is opened)
M.harpoon = {
  function()
    local path = utils.path.get_current_buffer_path()
    if path == nil then -- No buffer is opened
      return ""
    end

    local harpoon = require("harpoon") -- Harpoon is not loaded if no buffer/directory is opened
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
    local oil = package.loaded.oil
    return vim.fn.fnamemodify(oil.get_current_dir(), ":p:~:.")
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
    local terms = require("toggleterm.terminal")
    local term = terms.get(vim.b.toggle_number)
    if term == nil then
      return ""
    end
    return "Terminal " .. term.id .. ": " .. term:_display_name()
  end,
}

return M
