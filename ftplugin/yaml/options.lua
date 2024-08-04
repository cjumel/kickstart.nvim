local utils = require("utils")

-- [[ Colorcolumn ]]

-- Possible configuration file names for yamlfmt
local config_file_names = { ".yamlfmt", "yamlfmt.yml", "yamlfmt.yaml", ".yamlfmt.yaml", ".yamlfmt.yml" }

--- Get the right color column value for yamlfmt based on a configuration file.
---@param dir string Directory of the configuration file.
---@param file_name string Name of the configuration file.
---@return string
local function get_colorcolumn_from_file_func(dir, file_name)
  local file = io.open(dir .. "/" .. file_name, "r")
  if not file then
    return "" -- This shouldn't happen
  end

  for line in file:lines() do
    -- Capture the value of `max_line_length` but not if commented & not any comment after it
    -- "%s*" takes into account the indentation in Yaml files, accounting for any number of spaces or tabs
    local line_length_candidate = line:match("^%s*max_line_length: ([^%s]+)")
    if line_length_candidate ~= nil then -- A match is found
      local line_length = tonumber(line_length_candidate)
      file:close()
      return tostring(line_length + 1)
    end
  end
  file:close()
  return "" -- Correspond to default formatter value
end

--- Get the right color column value for yamlfmt for the current buffer. To do so, this function looks relevant
--- configuration files, and read in them the relevant line length.
---@return string
local function get_colorcolumn()
  local dir = utils.buffer.get_parent_dir()
  if dir == nil then
    return ""
  end

  for _ = 1, 50 do -- Virtually like a `while True`, but with a safety net to prevent infinite loops
    for _, file_name in ipairs(config_file_names) do
      if vim.fn.filereadable(dir .. "/" .. file_name) == 1 then
        return get_colorcolumn_from_file_func(dir, file_name)
      end
    end

    if dir == vim.env.HOME or dir == "/" then -- Stop at the home directory or root if file not in home directory
      return ""
    end
    dir = vim.fn.fnamemodify(dir, ":h") -- Change dir to its parent directory & loop again
  end

  vim.notify("Config file search limit reached", vim.log.levels.WARN)
  return ""
end

-- Display a column ruler at the relevant line length
if
  vim.opt_local.colorcolumn._value == "" -- Don't compute the value several times
  and vim.g.ruler_column_mode == "auto"
  and not utils.buffer.tooling_is_disabled()
then
  vim.opt_local.colorcolumn = get_colorcolumn()
end
