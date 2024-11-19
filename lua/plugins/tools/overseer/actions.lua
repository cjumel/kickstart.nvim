local M = {}

-- Callback to open the task list when a task is created
local function open_callback(task, _)
  local overseer = require("overseer")
  if task ~= nil then -- Prevent from opening the window when aborting during task creation
    overseer.open()
  end
end

function M.toggle_task_list()
  local overseer = require("overseer")
  overseer.toggle()
end

function M.all_templates()
  local overseer = require("overseer")
  overseer.run_template()
end

function M.all_templates_with_prompt()
  local overseer = require("overseer")
  overseer.run_template({ prompt = "always" })
end

function M.shell_template()
  local overseer = require("overseer")
  overseer.run_template({ name = "shell" }, open_callback)
end

function M.run_templates()
  local overseer = require("overseer")
  overseer.run_template({ tags = { "RUN" }, first = false }, open_callback)
end

function M.test_templates()
  local overseer = require("overseer")
  overseer.run_template({ tags = { "TEST" }, first = false })
end

function M.check_templates()
  local overseer = require("overseer")
  overseer.run_template({ tags = { "CHECK" }, first = false })
end

function M.format_templates()
  local overseer = require("overseer")
  overseer.run_template({ tags = { "FORMAT" }, first = false })
end

function M.build_templates()
  local overseer = require("overseer")
  overseer.run_template({ tags = { "BUILD" }, first = false })
end

function M.rerun_last_task()
  local overseer = require("overseer")
  local tasks = overseer.list_tasks({ recent_first = true })
  if vim.tbl_isempty(tasks) then
    vim.notify("No tasks found", vim.log.levels.WARN)
  else
    overseer.run_action(tasks[1], "restart")
  end
end

return M
