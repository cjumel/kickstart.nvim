local M = {}

--- Get the color column value corresponding to a formatter based on its configuration file.
---
--- This function can handle many different formatters by passing the format-specific logic in the parameters. It works
--- by checking candidate configuration files in all parent directories of the current file until the home or root
--- directory is found.
---@param config_file_names string[] Names of the configuration files to look for.
---@param is_config_file_func nil|fun(config_file_name: string, file): boolean Function to determine if a candidate
---   configuration file is the right one (default to always true).
---@param get_colorcolumn_from_file_func fun(config_file_name: string, file): string Function to extract the color
---   column value from the configuration file.
---@return string
function M.get_colorcolumn(config_file_names, is_config_file_func, get_colorcolumn_from_file_func)
  if is_config_file_func == nil then
    is_config_file_func = function(_, _) return true end
  end

  local file_path = vim.fn.expand("%:p") -- Absolute current file path (must be absolute to access its ancestors)
  if file_path == "" then -- Buffer is not an actual file
    return ""
  end
  local dir = vim.fn.fnamemodify(file_path, ":h") -- Parent directory of the current buffer file

  for _ = 1, 50 do -- Virtually like a `while True`, but with a safety net to prevent infinite loops
    for _, config_file_name in ipairs(config_file_names) do
      local config_file_path = dir .. "/" .. config_file_name
      if vim.fn.filereadable(config_file_path) == 1 then -- A candidate configuration file was found
        local file = io.open(config_file_path, "r")
        if not file then -- Make sure again that the file is readable to please the LSP
          return ""
        end

        if is_config_file_func(config_file_name, file) then
          local colorcolumn = get_colorcolumn_from_file_func(config_file_name, file)
          file:close()
          return colorcolumn
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

return M
