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

-- If file is in Harpoon list, show its index
-- This loads Harpoon so it's not lazy-loaded anymore
M.harpoon = {
  function()
    local harpoon = require("harpoon")

    local harpoon_list_length = harpoon:list():length()
    local current_file_path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")

    for index = 1, harpoon_list_length do
      local harpoon_file_path = harpoon:list():get(index).value
      if current_file_path == harpoon_file_path then
        return "H-" .. index .. "/" .. harpoon_list_length
      end
    end

    return ""
  end,
}

-- Show the path of the directory opened with Oil (instead of Oil's buffer path)
M.oil = {
  function()
    local ok, oil = pcall(require, "oil")
    if not ok then
      return ""
    end

    local current_dir = oil.get_current_dir()
    -- Truncate relative to cwd or home with "~" when possible
    local short_path = vim.fn.fnamemodify(current_dir, ":p:~:.")
    -- If path is cwd (relative path is empty), don't show path relative to project
    if short_path == "" then
      short_path = vim.fn.fnamemodify(current_dir, ":p:~")
    end
    return short_path
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

return M
