local constants = require("overseer.constants")
local STATUS = constants.STATUS

---@type overseer.ComponentFileDefinition
local comp = {
  desc = "set vim.g.last_task_status global variable when task is completed",
  constructor = function()
    return {
      on_start = function() vim.g.last_task_status = "in progress" end,
      on_complete = function(_, _, status)
        if status == STATUS.SUCCESS then
          vim.g.last_task_status = "success"
        elseif status == STATUS.FAILURE then
          vim.g.last_task_status = "failure"
        end
        require("lualine").refresh({ place = { "statusline" } })
      end,
    }
  end,
}

return comp
