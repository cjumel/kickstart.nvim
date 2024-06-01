local utils = require("utils")

-- Define custom colorcolumn parameters for Yamlfmt
local config_file_names = { ".yamlfmt", "yamlfmt.yml", "yamlfmt.yaml", ".yamlfmt.yaml", ".yamlfmt.yml" }
local is_config_file_func = nil
local get_colorcolumn_from_file_func = function(_, file)
  for line in file:lines() do
    -- Capture the value of `max_line_length` but not if commented & not any comment after it
    -- "%s*" takes into account the indentation in Yaml files, accounting for any number of spaces or tabs
    local line_length_candidate = line:match("^%s*max_line_length: ([^%s]+)")
    if line_length_candidate ~= nil then -- A match is found
      local line_length = tonumber(line_length_candidate)
      return tostring(line_length + 1)
    end
  end
  return "" -- Correspond to default formatter value
end

-- Display a column ruler at the relevant line length
if not vim.g.disable_colorcolumn then
  vim.opt_local.colorcolumn =
    utils.ftplugin.get_colorcolumn(config_file_names, is_config_file_func, get_colorcolumn_from_file_func)
end
