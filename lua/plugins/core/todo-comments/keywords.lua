local M = {}

M.todo = {
  "FIX",
  "FIXME",
  "BUG",
  "FIXIT",
  "ISSUE",
  "TODO",
  "PERF",
  "OPTIM",
  "PERFORMANCE",
  "OPTIMIZE",
  "TEST",
  "TESTING",
  "PASSED",
  "FAILED",
}

M.note = {
  "HACK",
  "WARN",
  "WARNING",
  "XXX",
  "NOTE",
  "INFO",
  "IMPORTANT",
}

M.private_todo = {
  "_TODO",
}

return M
