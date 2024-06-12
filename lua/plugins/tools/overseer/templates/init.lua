local M = {}

vim.list_extend(M, require("plugins.tools.overseer.templates.luajit"))
vim.list_extend(M, require("plugins.tools.overseer.templates.mypy"))
vim.list_extend(M, require("plugins.tools.overseer.templates.pre-commit"))
vim.list_extend(M, require("plugins.tools.overseer.templates.pytest"))
vim.list_extend(M, require("plugins.tools.overseer.templates.python"))

return M
