local utils = require("utils")

local tags = { "python", "pytest" }

return {
  {
    name = "Pytest file",
    condition = {
      callback = function(_)
        if vim.bo.filetype ~= "python" then
          return false
        end

        local cwd = vim.fn.getcwd()

        local pyproject_path = cwd .. "/pyproject.toml"
        if vim.fn.filereadable(pyproject_path) ~= 1 then
          return false
        end

        local tests_path = cwd .. "/tests"
        if vim.fn.isdirectory(tests_path) ~= 1 then
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
        cmd = { "pytest", path, params.args },
      }
    end,
    tags = tags,
  },
  {
    name = "Pytest directory",
    condition = {
      callback = function(_)
        if vim.bo.filetype ~= "oil" then
          return false
        end

        local cwd = vim.fn.getcwd()

        local pyproject_path = cwd .. "/pyproject.toml"
        if vim.fn.filereadable(pyproject_path) ~= 1 then
          return false
        end

        local tests_path = cwd .. "/tests"
        if vim.fn.isdirectory(tests_path) ~= 1 then
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
      local path = utils.path.get_current_oil_directory({ fallback = "cwd" })
      if path == nil then
        vim.notify("No directory provided or found")
        return {}
      end

      return {
        cmd = { "pytest", path, params.args },
      }
    end,
    tags = tags,
  },
  {
    name = "Pytest",
    condition = {
      callback = function(_)
        local cwd = vim.fn.getcwd()

        local pyproject_path = cwd .. "/pyproject.toml"
        if vim.fn.filereadable(pyproject_path) ~= 1 then
          return false
        end

        local tests_path = cwd .. "/tests"
        if vim.fn.isdirectory(tests_path) ~= 1 then
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
      return {
        cmd = { "pytest", params.args },
      }
    end,
    tags = tags,
  },
}
