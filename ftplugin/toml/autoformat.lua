local bufnr = vim.fn.bufnr()

--- Determine whether to disable auto-formatting for the current buffer or not, based on existing configuration files
--- (e.g. if a tool is configured and conflicts with the formatter).
---@return boolean
local function disable_autoformat()
  local config_file_names = { ".pre-commit-config.yaml" }
  local line_length_pattern = "- repo: https://github.com/pappasam/toml-sort"

  local file_path = vim.fn.expand("%:p") -- Get the current file path (must be absolute to access its ancestors)
  local dir = vim.fn.fnamemodify(file_path, ":h") -- Get the parent directory

  for _ = 1, 50 do -- Virtually like a `while True`, but with a safety net
    for _, config_file_name in ipairs(config_file_names) do
      local config_file_path = dir .. "/" .. config_file_name
      if vim.fn.filereadable(config_file_path) == 1 then -- A configuration file was found
        local file = io.open(config_file_path, "r")
        if not file then -- Unable to open file
          return false
        end
        for line in file:lines() do
          local start, end_ = string.find(line, line_length_pattern, 1, true)
          if start ~= nil and end_ ~= nil then -- The target line was found
            file:close()
            return true
          end
        end
        -- A config file is found but not the target line
        file:close()
        return false
      end
    end

    if dir == vim.env.HOME or dir == "/" then -- Stop at the home directory or root if file not in home directory
      return false
    else
      dir = vim.fn.fnamemodify(dir, ":h") -- Change dir to its parent directory & loop again
    end
  end

  vim.notify("Config file search limit reached", vim.log.levels.WARN)
  return false
end

if not vim.tbl_contains(vim.g.disable_autoformat_bufnrs or {}, bufnr) and disable_autoformat() then
  vim.g.disable_autoformat_bufnrs = vim.list_extend(vim.g.disable_autoformat_bufnrs or {}, { bufnr })
end
