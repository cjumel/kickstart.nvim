local utils = require("utils")

-- Define custom colorcolumn parameters for Stylua
local config_file_names = { ".stylua.toml", "stylua.toml" }
local is_config_file_func = nil
local get_colorcolumn_from_file_func = function(_, file)
  for line in file:lines() do
    -- Capture the value of `column_width` but not if commented & not any comment after it
    local line_length_candidate = line:match("^column_width = ([^%s]+)")
    if line_length_candidate ~= nil then -- A match is found
      local line_length = tonumber(line_length_candidate)
      return tostring(line_length + 1)
    end
  end
  return "121" -- Correspond to default formatter value
end

-- Display a column ruler at the relevant line length
if not vim.g.disable_colorcolumn then
  vim.opt_local.colorcolumn =
    utils.ftplugin.get_colorcolumn(config_file_names, is_config_file_func, get_colorcolumn_from_file_func)
end
