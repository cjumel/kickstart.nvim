local utils = require("utils")

local tags = { "pre-commit" }

return {
  {
    name = "Pre-commit run file",
    params = {
      path = {
        type = "string",
        desc = "Path of the file (default to the currently opened one)",
        optional = true,
        order = 1,
      },
      args = {
        type = "string",
        desc = "The additional arguments to pass to the command",
        optional = true,
        order = 2,
      },
    },
    builder = function(params)
      if params.path == nil then
        params.path = utils.path.get_current_file_path()
      else
        params.path = utils.path.normalize(params.path)
      end

      if params.path == nil then
        print("No file provided or found")
        return {}
      elseif vim.fn.filewritable(params.path) ~= 1 then
        print("Not a readable file: " .. params.path)
        return {}
      end

      return {
        cmd = { "pre-commit", "run", "--file", params.path, params.args },
      }
    end,
    tags = tags,
  },
  {
    name = "Pre-commit run directory",
    params = {
      path = {
        type = "string",
        desc = "Path of the directory (default to the currently opened one if in Oil buffer or to the current working directory",
        optional = true,
        order = 1,
      },
      args = {
        type = "string",
        desc = "The additional arguments to pass to the command",
        optional = true,
        order = 2,
      },
    },
    builder = function(params)
      if params.path == nil then
        params.path = utils.path.get_current_oil_directory({ fallback = "cwd" })
      else
        params.path = utils.path.normalize(params.path)
      end

      if params.path == nil then
        print("No directory provided or found")
        return {}
      elseif vim.fn.isdirectory(params.path) ~= 1 then
        print("Not a directory: " .. params.path)
        return {}
      end

      local pattern = ""
      if string.sub(params.path, -1) ~= "/" then
        pattern = pattern .. "/"
      end
      pattern = pattern .. "**/*"
      return {
        -- vim.fn.expandcmd is taken from the "shell" builtin template; without it pre-commit
        -- skips all the files in the directory
        cmd = vim.fn.expandcmd("pre-commit run --files " .. params.path .. pattern, params.args),
      }
    end,
    tags = tags,
  },
  {
    name = "Pre-commit run all files",
    params = {
      args = {
        type = "string",
        desc = "The additional arguments to pass to the command",
        optional = true,
        order = 1,
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
