-- [[ Options ]]

--- Look for a mdformat configuration file and output a colorcolumn value based on it or nil.
---@return string|nil
local function get_colorcolumn()
  local config_file_names = { ".mdformat.toml" }
  local line_length_pattern = "wrap = "

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

            local line_length_candidate = line.sub(line, end_ + 1)
            if line_length_candidate == "keep" or line_length_candidate == "no" then
              return nil
            else
              local line_length = tonumber(line.sub(line, end_ + 1))
              return tostring(line_length + 1)
            end
          end
        end

        -- A config file is found but no column_width line
        file:close()
        return nil
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

-- [[ Keymaps ]]

local utils = require("utils")

-- This keymap also catches comments with `#` in code blocks (e.g. in Python), but this is good enough
utils.keymap.set_move_pair(
  { "[t", "]t" }, -- Correspond to todo-comments in other filetypes, but not used in Markdown
  { function() vim.fn.search("^#") end, function() vim.fn.search("^#", "b") end },
  { { desc = "Next title", buffer = true }, { desc = "Previous title", buffer = true } }
)
