local utils = require("utils")

-- [[ Buffer exclusion ]]

--- Determine whether to disable tooling on the current buffer. More specifically, this function checks whether a
--- `toml-sort` pre-commit hook is setup on the current buffer, as it conflicts with Taplo.
---@return boolean
local function disable_tooling_callback(_)
  local git_root = utils.buffer.get_git_root()

  if git_root ~= nil then -- The cwd is in a Git repository
    local file_path = git_root .. "/.pre-commit-config.yaml"
    if vim.fn.filereadable(file_path) == 1 then -- There is a pre-commit configuration file
      local file = io.open(file_path, "r")
      if not file then -- Make sure again that the file is readable to please the LSP
        return false
      end

      -- Look for the `toml-sort` hook URL in the right format in any line of the file
      for line in file:lines() do
        -- In the following pattern, "^%s*" matches any number of spaces at the beginning of the line, and the rest
        -- corresponds to the target URL where the special characters (".", "-") are escaped with "%"
        if line:match("^%s*%- repo: https://github%.com/pappasam/toml%-sort") ~= nil then
          file:close()
          return true
        end
      end

      file:close()
      return false
    end
  end

  return false
end

-- Disable buffer tooling when relevant
if utils.buffer.should_disable_tooling(disable_tooling_callback) then
  utils.buffer.disable_tooling()
end

-- [[ Colorcolumn ]]

-- Possible configuration file names for Taplo
local config_file_names = { ".taplo.toml", "taplo.toml" }

--- Get the right color column value for Taplo based on a configuration file.
---@param dir string Directory of the configuration file.
---@param file_name string Name of the configuration file.
---@return string
local function get_colorcolumn_from_file_func(dir, file_name)
  local file = io.open(dir .. "/" .. file_name, "r")
  if not file then
    return "" -- This shouldn't happen
  end

  for line in file:lines() do
    -- Capture the value of `column_width` but not if commented & not any comment after it
    local line_length_candidate = line:match("^column_width = ([^%s]+)")
    if line_length_candidate ~= nil then -- A match is found
      local line_length = tonumber(line_length_candidate)
      file:close()
      return tostring(line_length + 1)
    end
  end
  file:close()
  return "81" -- Correspond to default formatter value
end

--- Get the right color column value for Taplo for the current buffer. To do so, this function looks relevant
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
  and vim.g.color_column_mode == "auto"
  and not utils.buffer.tooling_is_disabled()
then
  vim.opt_local.colorcolumn = get_colorcolumn()
end
