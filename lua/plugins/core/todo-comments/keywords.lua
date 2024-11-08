local M = {}

-- Personal todo-comment keyword for immediate tasks, to differentiate them with regular TODOs
M.personal_todo = "TODO_"

-- Actual todo-comment keywords, for tasks to be done
M.todo = {
  "FIX",
  "FIXME",
  "BUG",
  "FIXIT",
  "ISSUE",
  "TODO",
  "TODO_",
  "XXX",
  "PERF",
  "OPTIM",
  "PERFORMANCE",
  "OPTIMIZE",
  "TEST",
  "TESTING",
  "PASSED",
  "FAILED",
}

-- Note-related todo-comment keywords, for imporant information to provide to the reader, but not a task to be done
M.note = {
  "NOTE",
  "INFO",
  "HACK",
  "WARN",
  "WARNING",
}

return M
