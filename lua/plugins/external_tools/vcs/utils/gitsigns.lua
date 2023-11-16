local M = {}

local conflict_marker = "<<<<<<< \\|=======\\|>>>>>>> "

M.next_conflict = function()
  vim.cmd("silent!/" .. conflict_marker)
end
M.prev_conflict = function()
  vim.cmd("silent!?" .. conflict_marker)
end

return M
