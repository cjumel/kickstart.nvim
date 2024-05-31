local utils = require("utils")

--- Determine whether to disable Taplo auto-formatting for the current buffer, based on the presence of a `toml-sort`
--- hook configured for `pre-commit` in the current project, as both tools conflict with each other.
---@return boolean _ Whether to disable Taplo auto-formatting or not.
local function disable_autoformat()
  local git_root_path = utils.path.get_git_root()
  if git_root_path ~= nil then -- The cwd is in a Git repository
    local file_path = git_root_path .. "/.pre-commit-config.yaml"
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

local bufnr = vim.fn.bufnr()
if not vim.tbl_contains(vim.g.disable_autoformat_bufnrs or {}, bufnr) and disable_autoformat() then
  vim.g.disable_autoformat_bufnrs = vim.list_extend(vim.g.disable_autoformat_bufnrs or {}, { bufnr })
end
