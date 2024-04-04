local utils = require("utils")

local function pre_commit_has_config() return utils.dir.contain_files({ ".pre-commit-config.yaml" }) end
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
        return pre_commit_has_config() and vim.bo.filetype ~= "" and vim.bo.filetype ~= "oil"
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
      callback = function(_) return pre_commit_has_config() and vim.bo.filetype == "oil" end,
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
      callback = function(_) return pre_commit_has_config() end,
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
