--- Look at existing formatter configuration files to determine the relevant `colorcolumn` option value for Markdown.
--- More specifically, this function looks for a `mdformat` configuration file named `.mdformat.toml` in all parent
--- directories until the home or root directory. If it finds one, it looks at the value of the `wrap` key to determine
--- the line length, if it's not `"no"` or `"keep"`.
---@return string
local function get_colorcolumn()
  local file_path = vim.fn.expand("%:p") -- Absolute current file path (must be absolute to access its ancestors)
  local dir = vim.fn.fnamemodify(file_path, ":h") -- Parent directory of the current file

  for _ = 1, 50 do -- Virtually like a `while True`, but with a safety net
    local config_file_path = dir .. "/.mdformat.toml" -- Only one file to check
    if vim.fn.filereadable(config_file_path) == 1 then -- A configuration file is found
      local file = io.open(config_file_path, "r")
      if not file then -- Unable to open file
        return ""
      end

      -- Look for the line length value, as the value of the `wrap` key in the configuration file
      for line in file:lines() do
        if line:sub(1, 1) ~= "#" then -- Skip comment lines
          -- Capture the value of the `wrap` key but not comments after it
          local line_length_candidate = line:match("wrap = ([^%s]+)")
          if line_length_candidate ~= nil then -- A match is found
            file:close()
            if line_length_candidate == "keep" or line_length_candidate == "no" then
              return ""
            else
              local line_length = tonumber(line_length_candidate)
              return tostring(line_length + 1)
            end
          end
        end
      end

      -- A config file is found but no line length
      file:close()
      return ""
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
if not vim.g.disable_colorcolumn then
  vim.opt_local.colorcolumn = get_colorcolumn()
end

-- Set conceal level to hide some information in the buffer; default to 0 (no concealment)
if not vim.g.disable_concealing then
  vim.opt_local.conceallevel = 2 -- Hide concealable text almost all the time
end
