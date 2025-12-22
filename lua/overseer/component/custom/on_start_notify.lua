---@type overseer.ComponentFileDefinition
local comp = {
  desc = "vim.notify when task is started",
  constructor = function()
    return {
      on_start = function(_, task)
        local message = string.format("Starting task: %s", task.name)
        local level = vim.log.levels.INFO
        vim.notify(message, level, { title = "overseer.nvim" })
      end,
    }
  end,
}

return comp
