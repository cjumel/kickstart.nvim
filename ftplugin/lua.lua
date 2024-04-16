--- Look for a Stylua configuration file and output a colorcolumn value based on it or nil.
---@return string|nil
local function get_colorcolumn()
  local config_file_names = { ".stylua.toml", "stylua.toml" }
  local cwd = vim.fn.getcwd()

  for _, config_file_name in ipairs(config_file_names) do
    local config_file_path = vim.fn.findfile(config_file_name, cwd .. ";")

    if config_file_path ~= "" then -- A configuration file was found
      local file = io.open(config_file_path, "r")
      if not file then -- Unable to open file
        return nil
      end

      local target = "column_width = "
      for line in file:lines() do
        local start, end_ = string.find(line, target, 1, true)
        if start ~= nil and end_ ~= nil then -- The column_width line was found
          file:close()

          local line_length_string = line.sub(line, end_ + 1)
          local line_length = tonumber(line_length_string) + 1
          return tostring(line_length)
        end
      end

      -- A config file is found but no column_width line
      file:close()
      return "121" -- 120 is the default line length
    end
  end

  return nil
end

-- Display a column ruler at the relevant line length
vim.opt_local.colorcolumn = get_colorcolumn()
