local M = {}

local function open_callback(task, _)
  local overseer = require("overseer")
  if task ~= nil then -- Prevent from opening the window when aborting during task creation
    overseer.open()
  end
end

function M.toggle()
  local overseer = require("overseer")
  overseer.toggle()
end

function M.run()
  local overseer = require("overseer")
  overseer.run_template({}, open_callback) -- Open Overseer window during the task
end

function M.run_in_background()
  local overseer = require("overseer")
  overseer.run_template({})
end

function M.run_with_prompt()
  local overseer = require("overseer")
  overseer.run_template({ prompt = "always" }, open_callback) -- Open Overseer window during the task
end

function M.run_last()
  local overseer = require("overseer")
  local tasks = overseer.list_tasks({ recent_first = true })
  if vim.tbl_isempty(tasks) then
    vim.notify("No tasks found", vim.log.levels.WARN)
  else
    overseer.run_action(tasks[1], "restart")
  end
end

return M
