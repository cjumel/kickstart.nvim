local utils = require("utils")

-- Define custom colorcolumn parameters for Ruff
-- This case is quite tricky, as it must deal with the standard case of ".ruff.toml"/"ruff.toml" and with the special
-- case of generic Python configuration file ("pyproject.toml") where the Ruff configuration is only a sub-section, as
-- well as the possibility to extend another configuration file with Ruff
local config_file_names = { ".ruff.toml", "ruff.toml", "pyproject.toml" }
local is_config_file_func = function(config_file_name, file)
  return false -- TODO: really implement this
end
local get_colorcolumn_from_file_func = function(config_file_name, file)
  return "" -- TODO: really implement this
end

-- TODO: remove the following commented function, it's only ket to ease the re-implementation of the code above
--
-- local function get_colorcolumn()
--   local file_path = vim.fn.expand("%:p") -- Absolute current file path (must be absolute to access its ancestors)
--   if file_path == "" then -- Not an actual file
--     return ""
--   end
--   local dir = vim.fn.fnamemodify(file_path, ":h") -- Parent directory of the current file
--
--   for _ = 1, 50 do -- Virtually like a `while True`, but with a safety net
--     for _, config_file_name in ipairs({ ".ruff.toml", "ruff.toml", "pyproject.toml" }) do
--       local config_file_path = dir .. "/" .. config_file_name
--       if vim.fn.filereadable(config_file_path) == 1 then -- A configuration file was found
--         local file = io.open(config_file_path, "r")
--         if not file then -- Unable to open file
--           return ""
--         end
--
--         -- Look for the color column value, as the value of the `line-length` key in Ruff configuration files
--         if config_file_name ~= "pyproject.toml" then
--           for line in file:lines() do
--             if line:sub(1, 1) ~= "#" then -- Skip comment lines
--               -- Capture the value of the `line-length` key but not comments after it
--               local line_length_candidate = line:match("line-length = ([^%s]+)")
--               if line_length_candidate ~= nil then -- A match if found
--                 file:close()
--                 local line_length = tonumber(line_length_candidate)
--                 return tostring(line_length + 1)
--               end
--             end
--           end
--
--           -- A config file is found but no color column value
--           file:close()
--           return "89"
--
--         -- Look for the color column value, as the value of the `line-length` key in `tool.ruff` section in a
--         -- `pyproject.toml`
--         else
--           local is_in_ruff_section = false -- Actually "is after Ruff section title" but close enough
--           local extends_ruff_config = false
--           local start, end_
--
--           for line in file:lines() do
--             if not is_in_ruff_section then
--               start, end_ = string.find(line, "tool.ruff", 1, true)
--               if start == 2 and end_ ~= nil then -- Target is found at the beginning of the line (except for a "[")
--                 is_in_ruff_section = true -- Ruff section is starting after this line
--               end
--             else
--               start, end_ = string.find(line, "line-length = ", 1, true)
--               if start == 1 and end_ ~= nil then -- Target is found at the beginning of the line
--                 file:close()
--
--                 local line_length = tonumber(line.sub(line, end_ + 1))
--                 return tostring(line_length + 1)
--               end
--
--               if not extends_ruff_config then
--                 start, end_ = string.find(line, "extend = ", 1, true)
--                 if start == 1 and end_ ~= nil then -- Target is found at the beginning of the line
--                   extends_ruff_config = true
--                 end
--               end
--             end
--           end
--           file:close()
--
--           -- A config file is found but no line length line & it doesn't extend another config
--           if is_in_ruff_section and not extends_ruff_config then
--             return "89"
--           end
--         end
--       end
--     end
--
--     if dir == vim.env.HOME or dir == "/" then -- Stop at the home directory or root if file not in home directory
--       return ""
--     end
--     dir = vim.fn.fnamemodify(dir, ":h") -- Change dir to its parent directory & loop again
--   end
--
--   vim.notify("Config file search limit reached", vim.log.levels.WARN)
--   return ""
-- end

-- Display a column ruler at the relevant line length
if not vim.g.disable_colorcolumn then
  vim.opt_local.colorcolumn =
    utils.ftplugin.get_colorcolumn(config_file_names, is_config_file_func, get_colorcolumn_from_file_func)
end
