local utils = require("utils")

local tags = { "pre-commit" }

return {
  {
    name = "Pre-commit run file",
    condition = {
      callback = function()
        if vim.bo.filetype == "" then -- No file opened
          return false
        elseif vim.bo.filetype == "oil" then
          return false
        end
        return true
      end,
    },
    params = {
      args = {
        type = "string",
        desc = "Additional arguments",
        optional = true,
      },
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
      filetype = "oil",
    },
    params = {
      args = {
        type = "string",
        desc = "Additional arguments",
        optional = true,
      },
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
    name = "Pre-commit run cwd",
    params = {
      args = {
        type = "string",
        desc = "Additional arguments",
        optional = true,
      },
    },
    builder = function(params)
      local path = utils.path.normalize(vim.fn.getcwd())
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
    params = {
      args = {
        type = "string",
        desc = "Additional arguments",
        optional = true,
      },
    },
    builder = function(params)
      return {
        cmd = { "pre-commit", "run", "--all-files", params.args },
      }
    end,
    tags = tags,
  },
}
