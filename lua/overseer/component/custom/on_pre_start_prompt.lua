---@type overseer.ComponentFileDefinition
local comp = {
  desc = "prompt user for arguments before task is started",
  constructor = function()
    return {
      on_pre_start = function(_, task)
        if task.from_template.params.prompt then
          local args_string = vim.fn.input("Arguments")
          if args_string ~= "" then
            task.name = task.name .. " " .. args_string
            local args = vim.split(args_string, " +")
            task.cmd = vim.list_extend(task.cmd, args)
          end
        end
      end,
    }
  end,
}

return comp
