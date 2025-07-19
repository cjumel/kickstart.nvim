local M = {}

local orange = "#ff9e64"
local green = "#98c379"
local red = "#e06c75"
local blue = "#61afef"

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

M.last_task_status = {
  function()
    if vim.g.last_task_status == "success" then
      return ""
    elseif vim.g.last_task_status == "failure" then
      return ""
    elseif vim.g.last_task_status == "in progress" then
      return ""
    end
  end,
  cond = function() return vim.g.last_task_status ~= nil end,
  color = function()
    if vim.g.last_task_status == "success" then
      return { fg = green }
    elseif vim.g.last_task_status == "failure" then
      return { fg = red }
    elseif vim.g.last_task_status == "in progress" then
      return { fg = blue }
    end
  end,
}

return M
