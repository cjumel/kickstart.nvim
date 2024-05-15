--- Look at global editor variables and existing formatter configuration files to determine the relevant `colorcolumn`
--- option value.
--- This implementation is quite different from other similar functions because it needs to look for both pure Ruff
--- configuration files (like ".ruff.toml") and generic Python configuration files ("pyproject.toml"), which may not
--- configure Ruff or does configure Ruff but extends another one where the line length is defined. This tries to take
--- all these cases into account but takes some shortcuts.
---@return string
local function get_colorcolumn()
  if vim.g.disable_colorcolumn then
    return ""
  end

  local config_file_names = { ".ruff.toml", "ruff.toml", "pyproject.toml" }
  local default_line_length = 88
  local line_length_pattern = "line-length = "

  local file_path = vim.fn.expand("%:p") -- Get the current file path (must be absolute to access its ancestors)
  local dir = vim.fn.fnamemodify(file_path, ":h") -- Get the parent directory

  for _ = 1, 50 do -- Virtually like a `while True`, but with a safety net
    for _, config_file_name in ipairs(config_file_names) do
      local config_file_path = dir .. "/" .. config_file_name
      if vim.fn.filereadable(config_file_path) == 1 then -- A configuration file was found
        local file = io.open(config_file_path, "r")
        if not file then -- Unable to open file
          return ""
        end

        if config_file_name ~= "pyproject.toml" then -- Regular case of pure config files
          for line in file:lines() do
            local start, end_ = string.find(line, line_length_pattern, 1, true)
            if start == 1 and end_ ~= nil then -- The target line was found and is not a comment
              file:close()

              local line_length = tonumber(line.sub(line, end_ + 1))
              return tostring(line_length + 1)
            end
          end

          -- A config file is found but no line length line
          file:close()
          return tostring(default_line_length + 1)
        else -- Special case of "pyproject.toml" files
          local is_in_ruff_section = false -- Actually "is after Ruff section title" but close enough
          local extends_ruff_config = false
          local start, end_

          for line in file:lines() do
            if not is_in_ruff_section then
              start, end_ = string.find(line, "tool.ruff", 1, true)
              if start == 2 and end_ ~= nil then -- Target is found at the beginning of the line (except for a "[")
                is_in_ruff_section = true -- Ruff section is starting after this line
              end
            else
              start, end_ = string.find(line, line_length_pattern, 1, true)
              if start == 1 and end_ ~= nil then -- Target is found at the beginning of the line
                file:close()

                local line_length = tonumber(line.sub(line, end_ + 1))
                return tostring(line_length + 1)
              end

              if not extends_ruff_config then
                start, end_ = string.find(line, "extend = ", 1, true)
                if start == 1 and end_ ~= nil then -- Target is found at the beginning of the line
                  extends_ruff_config = true
                end
              end
            end
          end
          file:close()

          -- A config file is found but no line length line & it doesn't extend another config
          if is_in_ruff_section and not extends_ruff_config then
            return tostring(default_line_length + 1)
          end
        end
      end
    end

    if dir == vim.env.HOME or dir == "/" then -- Stop at the home directory or root if file not in home directory
      return ""
    else
      dir = vim.fn.fnamemodify(dir, ":h") -- Change dir to its parent directory & loop again
    end
  end

  vim.notify("Config file search limit reached", vim.log.levels.WARN)
  return ""
end

-- Display a column ruler at the relevant line length
vim.opt_local.colorcolumn = get_colorcolumn()
