local util = require("overseer.util")

---@type overseer.ComponentFileDefinition
local comp = {
  desc = "vim.notify when task is completed",
  constructor = function()
    return {
      on_complete = function(_, task, status)
        local level = util.status_to_log_level(status)
        local message = string.format("%s %s", status, task.name)
        vim.notify(message, level, { title = "overseer.nvim" })
      end,
    }
  end,
}

return comp
