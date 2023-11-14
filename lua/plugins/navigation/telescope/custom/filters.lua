local M = {}

M.command_history_filter_fn = function(cmd)
  -- Discard commands like "w", "q", "wq", "wqa", etc.
  if string.len(cmd) < 4 then
    return false
  end
  return true
end

local function is_whitespace(line)
  return vim.fn.match(line, [[^\s*$]]) ~= -1
end

local function all(tbl, check)
  for _, entry in ipairs(tbl) do
    if not check(entry) then
      return false
    end
  end
  return true
end

M.whitespace_yank_filter_fn = function(data)
  return not all(data.event.regcontents, is_whitespace)
end

return M
