local util = require("overseer.util")

---@type overseer.ComponentFileDefinition
local comp = {
  desc = "vim.notify when task is completed",
  constructor = function()
    return {
      on_start = function(_, task)
        local message = string.format("Starting task: %s", task.name)
        local level = vim.log.levels.INFO
        vim.notify(message, level, { title = "overseer.nvim" })
      end,
      on_complete = function(_, task, status)
        local message = string.format("%s: %s", status, task.name)
        local level = util.status_to_log_level(status)
        vim.notify(message, level, { title = "overseer.nvim" })
      end,
    }
  end,
}

return comp
