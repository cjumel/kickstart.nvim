--- Look for a Stylua configuration file and output a colorcolumn value based on it or nil.
---@return string|nil
local function get_colorcolumn()
  local config_file_names = { ".stylua.toml", "stylua.toml" }
  local default_line_length = 120
  local line_length_pattern = "column_width = "

  local file_path = vim.fn.expand("%:p") -- Get the current file path (must be absolute to access its ancestors)
  local dir = vim.fn.fnamemodify(file_path, ":h") -- Get the parent directory

  for _ = 1, 50 do -- Virtually like a `while True`, but with a safety net
    for _, config_file_name in ipairs(config_file_names) do
      local config_file_path = dir .. "/" .. config_file_name
      if vim.fn.filereadable(config_file_path) == 1 then -- A configuration file was found
        local file = io.open(config_file_path, "r")
        if not file then -- Unable to open file
          return nil
        end

        for line in file:lines() do
          local start, end_ = string.find(line, line_length_pattern, 1, true)
          if start == 1 and end_ ~= nil then -- The target line was found and is not a comment (start == 1)
            file:close()

            local line_length = tonumber(line.sub(line, end_ + 1))
            return tostring(line_length + 1)
          end
        end

        -- A config file is found but no column_width line
        file:close()
        return tostring(default_line_length + 1)
      end
    end

    if dir == vim.env.HOME or dir == "/" then -- Stop at the home directory or root if file not in home directory
      return nil
    else
      dir = vim.fn.fnamemodify(dir, ":h") -- Change dir to its parent directory & loop again
    end
  end

  vim.notify("Config file search limit reached", vim.log.levels.WARN)
end

-- Display a column ruler at the relevant line length
if not vim.g.disable_colorcolumn then
  vim.opt_local.colorcolumn = get_colorcolumn()
end

--- Yank the path of the current Lua module.
---@return nil
local function yank_module_path()
  local path = vim.fn.expand("%")
  path = vim.fn.fnamemodify(path, ":.")

  path = path:gsub("^lua/", "") -- Remove the "lua/" prefix if it exists
  path = path:gsub("%.lua$", "") -- Remove the ".lua" extension
  path = path:gsub(".init$", "") -- Remove the ".init" suffix (in case in an init.lua file)
  path = path:gsub("/", ".") -- Replace slashes with dots

  vim.fn.setreg('"', path)
  vim.notify('Yanked "' .. path .. '"')
end

vim.keymap.set("n", "<leader>ym", yank_module_path, { buffer = true, desc = "[Y]ank: current Lua [M]odule" })
