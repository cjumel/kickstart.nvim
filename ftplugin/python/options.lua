local utils = require("utils")

-- [[ Format options ]]

-- Format options are adapted from Lua's default one in Neovim, defined in `nvim/runtime/ftplugin/lua.vim` with
--  `setlocal formatoptions-=t formatoptions+=croql`
-- Default formation options are: "tcqj"
vim.opt_local.formatoptions:remove("t")
vim.opt_local.formatoptions:append("rol")

-- [[ Colorcolumn ]]
-- The case of determining the right colorcolumn for Ruff is quite tricky compared to other formatters, as it must deal
-- with the standard case of ".ruff.toml"/"ruff.toml" but also with the special case of generic Python configuration
-- file ("pyproject.toml") where the Ruff configuration is only a sub-section, as well as the possibility to extend
-- another configuration file with Ruff

-- Possible configuration file names for Ruff
local config_file_names = { ".ruff.toml", "ruff.toml", "pyproject.toml" }

--- Determine if a file is a Ruff configuration file or not. For file named ".ruff.toml" or "ruff.toml", it's a Ruff
--- configuration file. For "pyproject.toml", it's a Ruff configuration file if a `tool.ruff` section or subsection is
--- found.
---@param dir string Directory of the configuration file.
---@param file_name string Name of the configuration file.
---@return boolean
local function is_config_file_func(dir, file_name)
  if vim.tbl_contains({ ".ruff.toml", "ruff.toml" }, file_name) then
    return true
  end

  -- Case of a `pyproject.toml` (make sure Ruff is configured in it through a `tool.ruff` section or subsection)
  local file = io.open(dir .. "/" .. file_name, "r")
  if not file then
    return false -- This shouldn't happen
  end

  for line in file:lines() do
    if line:match("^%[tool%.ruff.*%]") then
      file:close()
      return true
    end
  end

  file:close()
  return false
end

local get_colorcolumn_from_file_func -- Need to be declared beforehand to allow recursive calls

--- Get the right color column value for Ruff based on a configuration file.
---@param dir string Directory of the configuration file.
---@param file_name string Name of the configuration file.
---@return string
function get_colorcolumn_from_file_func(dir, file_name)
  local is_ruff_config_file = false -- Whether the file is a dedicated Ruff config file or not
  local ruff_is_setup = false -- Whether Ruff has been setup in this config file or not
  local ruff_main_setup_is_over = false -- Whether the main section of Ruff setup is over or not
  local ruff_extended_file = nil -- The file extended by Ruff, if any

  if vim.tbl_contains({ ".ruff.toml", "ruff.toml" }, file_name) then
    is_ruff_config_file = true
    ruff_is_setup = true
  end

  local file = io.open(dir .. "/" .. file_name, "r")
  if not file then
    return "" -- This shouldn't happen
  end

  for line in file:lines() do
    if not ruff_is_setup then -- Only possible in `pyproject.toml`
      if line:match("^%[tool%.ruff.*%]") ~= nil then -- Any Ruff section or subsection is found
        ruff_is_setup = true
      end
    end

    if ruff_is_setup and not ruff_main_setup_is_over then
      if is_ruff_config_file then
        if line:match("^%[.*%]") then -- Any section or subsection is found
          ruff_main_setup_is_over = true
        end
      else
        if
          line:match("^%[tool%.ruff%..*%]") -- Any Ruff subsection is found
          or (line:match("^%[.*%]") and not line:match("^%[tool%.ruff.*%]")) -- Any not-Ruff section is found
        then
          ruff_main_setup_is_over = true
        end
      end
    end

    if ruff_is_setup and not ruff_main_setup_is_over then
      -- Capture the value of `line-length` but not if commented & not any comment after it
      local line_length_candidate = line:match("^line%-length = ([^%s]+)")
      if line_length_candidate ~= nil then -- A match is found
        local line_length = tonumber(line_length_candidate)
        file:close()
        return tostring(line_length + 1)
      end

      if ruff_extended_file == nil then
        -- Capture the value of `extend` but not if commented & not any comment after it
        local ruff_extended_file_candidate = line:match([[^extend = "([^%s]+)"]])
        if ruff_extended_file_candidate ~= nil then -- A match is found
          ruff_extended_file = ruff_extended_file_candidate
        end
      end
    end
  end

  -- At this point, Ruff should have been setup but no line length has been found
  file:close()
  if ruff_extended_file ~= nil then
    return get_colorcolumn_from_file_func(dir, ruff_extended_file)
  end
  return "89" -- Correspond to default formatter value
end

--- Get the right color column value for Ruff for the current buffer. To do so, this function looks relevant
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
        if is_config_file_func(dir, file_name) then
          return get_colorcolumn_from_file_func(dir, file_name)
        end
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
