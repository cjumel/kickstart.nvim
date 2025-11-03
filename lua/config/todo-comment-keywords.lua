local M = {}

M.todo_private = {
  "_TODO",
}

M.todo_main = vim.list_extend(vim.deepcopy(M.todo_private), {
  "TODO",
  "FIXME",
  "BUG",
})

M.todo_all = vim.list_extend(vim.deepcopy(M.todo_main), {
  "FIX",
  "FIXIT",
  "ISSUE",
  "PERF",
  "OPTIM",
  "PERFORMANCE",
  "OPTIMIZE",
  "TEST",
  "TESTING",
  "PASSED",
  "FAILED",
})

M.note_main = {
  "NOTE",
  "HACK",
  "WARN",
}

M.note_all = vim.list_extend(vim.deepcopy(M.note_main), {
  "WARNING",
  "XXX",
  "INFO",
  "IMPORTANT",
})

return M
