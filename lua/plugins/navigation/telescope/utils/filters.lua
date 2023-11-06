local M = {}

M.command_history_filter_fn = function(cmd)
  -- Discard commands like "w", "q", "wq", "wqa", etc.
  if string.len(cmd) < 4 then
    return false
  end
  return true
end

return M
