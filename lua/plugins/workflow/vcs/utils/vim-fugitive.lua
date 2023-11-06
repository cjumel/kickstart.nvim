local M = {}

local function is_empty_string(s)
  return s == nil or s == ""
end

M.get_value = function(opts, default)
  if not is_empty_string(opts.args) then
    return opts.args
  else
    return default
  end
end

return M
