local M = {}

local orange = "#ff9e64"

M.empty = { function() return "" end }

M.macro = { -- Display macro recording status when there is one
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
  color = { fg = orange },
}

M.searchcount = {
  "searchcount",
  color = { fg = orange },
}

M.oil = {
  function()
    local oil = package.loaded.oil
    if oil ~= nil then
      local path = oil.get_current_dir()
      return vim.fn.fnamemodify(path, ":p:~:.")
    end
  end,
}

return M
