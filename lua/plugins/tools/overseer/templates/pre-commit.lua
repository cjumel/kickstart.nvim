local utils = require("utils")

--- Check if pre-commit is setup by checking if it has a configuration file in the root of the
--- Git repository containing the current project.
---@return boolean
local function pre_commit_is_setup()
  local repository_root_path = utils.project.get_repository_root_path()
  if repository_root_path == nil then -- Not in a Git repository
    return false
  end

  local config_file_path = repository_root_path .. "/.pre-commit-config.yaml"
  return vim.fn.filereadable(config_file_path) == 1
end

local args = {
  type = "string",
  desc = "Additional arguments",
  optional = true,
}
local tags = { "pre-commit" }

return {
  {
    name = "Pre-commit run file",
    condition = {
      callback = function(_) return pre_commit_is_setup() and vim.bo.filetype ~= "" and vim.bo.filetype ~= "oil" end,
    },
    params = {
      args = args,
    },
    builder = function(params)
      local path = utils.path.get_current_file_path()
      if path == nil then
        vim.notify("No file found")
        return {}
      end

      return {
        cmd = { "pre-commit", "run", "--file", path, params.args },
      }
    end,
    tags = tags,
  },
  {
    name = "Pre-commit run directory",
    condition = {
      callback = function(_) return pre_commit_is_setup() and vim.bo.filetype == "oil" end,
    },
    params = {
      args = args,
    },
    builder = function(params)
      local path = utils.path.get_current_oil_directory()
      if path == nil then
        vim.notify("No directory found")
        return {}
      end

      local pattern = ""
      if string.sub(path, -1) ~= "/" then
        pattern = pattern .. "/"
      end
      pattern = pattern .. "**/*"
      return {
        -- vim.fn.expandcmd is taken from the "shell" builtin template; without it pre-commit
        -- skips all the files in the directory
        cmd = vim.fn.expandcmd("pre-commit run --files " .. path .. pattern, params.args),
      }
    end,
    tags = tags,
  },
  {
    name = "Pre-commit run all files",
    condition = {
      callback = function(_) return pre_commit_is_setup() end,
    },
    params = {
      args = args,
    },
    builder = function(params)
      return {
        cmd = { "pre-commit", "run", "--all-files", params.args },
      }
    end,
    tags = tags,
  },
}
