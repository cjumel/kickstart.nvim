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
