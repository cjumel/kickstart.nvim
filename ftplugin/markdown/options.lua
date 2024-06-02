local utils = require("utils")

-- [[ Colorcolumn ]]

-- Possible configuration file names for mdformat
local config_file_names = { ".mdformat.toml" }

--- Get the right color column value for mdformat based on a configuration file.
---@param dir string Directory of the configuration file.
---@param file_name string Name of the configuration file.
---@return string
local get_colorcolumn_from_file_func = function(dir, file_name)
  local file = io.open(dir .. "/" .. file_name, "r")
  if not file then
    return "" -- This shouldn't happen
  end

  for line in file:lines() do
    -- Capture the value of `wrap` but not if commented & not any comment after it
    local line_length_candidate = line:match("^wrap = ([^%s]+)")
    if line_length_candidate ~= nil then -- A match is found
      if line_length_candidate == "keep" or line_length_candidate == "no" then
        file:close()
        return ""
      else
        local line_length = tonumber(line_length_candidate)
        file:close()
        return tostring(line_length + 1)
      end
    end
  end
  file:close()
  return "" -- Correspond to default formatter value
end

--- Get the right color column value for mdformat for the current buffer. To do so, this function looks at relevant
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
  vim.opt_local.colorcolumn._value == "" -- Prevent computing the value several times
  and not (vim.g.disable_colorcolumn or utils.buffer.tooling_is_disabled())
then
  vim.opt_local.colorcolumn = get_colorcolumn()
end

-- [[ Conceallevel ]]

-- Set conceal level to hide some information in the buffer; default to 0 (no concealment)
if
  vim.opt_local.conceallevel._value == "" -- Prevent computing the value several times
  and not vim.g.disable_concealing
then
  vim.opt_local.conceallevel = 2 -- Hide concealable text almost all the time
end
