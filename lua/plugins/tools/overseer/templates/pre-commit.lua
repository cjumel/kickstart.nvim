local utils = require("utils")

--- Check in all the parent directories for the pre-commit configuration file until the home
--- directory.
---@return boolean
local function pre_commit_is_setup()
  local dir_path = vim.fn.getcwd()
  if dir_path == nil then -- No directory found
    return false
  end
  dir_path = vim.fn.fnamemodify(dir_path, ":p:~") -- Make home directory prefix replaced by "~"
  if string.sub(dir_path, 1, 1) ~= "~" then -- Path is not in the home directory
    return false
  end
  if string.sub(dir_path, -1) == "/" then -- Path has a trailing slash
    dir_path = string.sub(dir_path, 1, -2)
  end

  while dir_path ~= "~" do
    -- File path needs to be expanded for vim.fn.filereadable to work
    local file_path = vim.fn.expand(dir_path .. "/.pre-commit-config.yaml")
    if vim.fn.filereadable(file_path) == 1 then
      return true
    end
    dir_path = vim.fn.fnamemodify(dir_path, ":h") -- Move to the parent directory
  end
  return false
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
      callback = function(_)
        return pre_commit_is_setup() and vim.bo.filetype ~= "" and vim.bo.filetype ~= "oil"
      end,
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
