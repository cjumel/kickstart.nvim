local utils = require("utils")

local arguments = require("plugins.tools.overseer.arguments")

local tags = { "python", "pytest" }

local function get_pytest_builder(opts)
  opts = opts or {}
  local mode = opts.mode or "dir" -- "file" or "dir"
  local extra_args = opts.extra_args or {}

  return function(params)
    local arguments_path = arguments.get_path(params, { mode = mode })

    if mode == "dir" then
      if vim.fn.isdirectory(arguments_path) == 1 then
        return {
          cmd = utils.table.concat_arrays({ { "pytest" }, extra_args, { arguments_path } }),
        }
      elseif arguments_path == nil then -- No path was provided
        return {
          cmd = utils.table.concat_arrays({ { "pytest" }, extra_args }),
        }
      else
        print("Not a directory: " .. arguments_path)
        return {}
      end
    elseif mode == "file" then
      if vim.fn.filereadable(arguments_path) == 1 then
        return {
          cmd = utils.table.concat_arrays({ { "pytest" }, extra_args, { arguments_path } }),
        }
      elseif arguments_path == nil then
        print("No path was provided")
        return {}
      else
        print("Not a readable file: " .. arguments_path)
        return {}
      end
    end
  end
end

return {
  {
    name = "Pytest",
    builder = function(params)
      return {
        cmd = vim.fn.expandcmd("pytest " .. params.args),
      }
    end,
    desc = "Run pytest with arbitrary arguments",
    tags = tags,
    _user_command_nargs = "*",
  },
  {
    name = "Pytest file",
    builder = get_pytest_builder({ mode = "file" }),
    desc = "Run pytest on a file passed as argument or on the current buffer",
    tags = tags,
    _user_command_nargs = "?",
  },
  {
    name = "Pytest file fast",
    builder = get_pytest_builder({ mode = "file", extra_args = { "-m", "not slow" } }),
    desc = "Run pytest fast tests on a file passed as argument or on the current buffer",
    tags = tags,
    _user_command_nargs = "?",
  },
  {
    name = "Pytest file slow",
    builder = get_pytest_builder({ mode = "file", extra_args = { "-m", "slow" } }),
    tags = tags,
    desc = "Run pytest slow tests on a file passed as argument or on the current buffer",
    _user_command_nargs = "?",
  },
  {
    name = "Pytest directory",
    builder = get_pytest_builder({ mode = "dir" }),
    desc = "Run pytest on a directory passed as argument, or on the current directory if in an Oil buffer, or on the current working directory",
    tags = tags,
    _user_command_nargs = "?",
  },
  {
    name = "Pytest directory fast",
    builder = get_pytest_builder({ mode = "dir", extra_args = { "-m", "not slow" } }),
    desc = "Run pytest fast tests on a directory passed as argument, or on the current directory if in an Oil buffer, or on the current working directory",
    tags = tags,
    _user_command_nargs = "?",
  },
  {
    name = "Pytest directory slow",
    builder = get_pytest_builder({ mode = "dir", extra_args = { "-m", "slow" } }),
    desc = "Run pytest slow tests on a directory passed as argument, or on the current directory if in an Oil buffer, or on the current working directory",
    tags = tags,
    _user_command_nargs = "?",
  },
}
