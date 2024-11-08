local keywords = require("plugins.core.todo-comments.keywords")

local M = {}

function M.find_personal_todos()
  local keyword_string = keywords.personal_todo
  vim.cmd("TodoTelescope layout_strategy=vertical keywords=" .. keyword_string)
end

function M.find_todos()
  local keyword_string = table.concat(keywords.todo, ",")
  vim.cmd("TodoTelescope layout_strategy=vertical keywords=" .. keyword_string)
end

function M.find_notes()
  local keywords_string = table.concat(keywords.note, ",")
  vim.cmd("TodoTelescope layout_strategy=vertical keywords=" .. keywords_string)
end

function M.view_personal_todos() vim.cmd("Trouble todo_personal_todo toggle") end

function M.view_todos() vim.cmd("Trouble todo_todo toggle") end

function M.view_notes() vim.cmd("Trouble todo_note toggle") end

function M.next_personal_todo()
  local tdc = require("todo-comments")
  tdc.jump_next({ keywords = { keywords.personal_todo } })
end

function M.prev_personal_todo()
  local tdc = require("todo-comments")
  tdc.jump_prev({ keywords = { keywords.personal_todo } })
end

function M.next_todo()
  local tdc = require("todo-comments")
  tdc.jump_next({ keywords = keywords.todo })
end

function M.prev_todo()
  local tdc = require("todo-comments")
  tdc.jump_prev({ keywords = keywords.todo })
end

function M.next_note()
  local tdc = require("todo-comments")
  tdc.jump_next({ keywords = keywords.note })
end

function M.prev_note()
  local tdc = require("todo-comments")
  tdc.jump_prev({ keywords = keywords.note })
end

return M
