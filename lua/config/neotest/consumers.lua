local M = {}

M.notify = function(client)
  client.listeners.results = function(_, results, partial)
    if partial then
      return
    end
    local total = 0
    local passed = 0
    for _, r in pairs(results) do
      total = total + 1
      if r.status == "passed" then
        passed = passed + 1
      end
    end
    if passed == total then
      vim.notify("SUCCESS: " .. passed .. "/" .. total .. " tests passed.", vim.log.levels.INFO, { title = "Neotest" })
    else
      vim.notify("FAILURE: " .. passed .. "/" .. total .. " tests passed.", vim.log.levels.ERROR, { title = "Neotest" })
    end
  end
end

M.last_task_status = function(client)
  client.listeners.starting = function()
    vim.g.last_task_status = "in progress"
    require("lualine").refresh({ place = { "statusline" } })
  end
  client.listeners.results = function(_, results, partial)
    if partial then
      return
    end
    local total = 0
    local passed = 0
    for _, r in pairs(results) do
      total = total + 1
      if r.status == "passed" then
        passed = passed + 1
      end
    end
    if passed == total then
      vim.g.last_task_status = "success"
    else
      vim.g.kast_task_status = "error"
    end
    require("lualine").refresh({ place = { "statusline" } })
  end
end

return M
