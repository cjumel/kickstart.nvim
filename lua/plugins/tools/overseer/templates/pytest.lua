local utils = require("utils")

local tags = { "python", "pytest" }

local function get_pytest_file_builder(args)
  args = args or {}

  return function(params)
    local path = utils.path.get_currrent_file_path()

    if path == nil then
      print("No file is opened")
      return {}
    elseif vim.fn.filereadable(path) ~= 1 then
      print("Not a readable file: " .. path)
      return {}
    end

    return {
      cmd = utils.table.concat_arrays({ { "pytest" }, args, { path, params.args } }),
    }
  end
end

local function get_pytest_directory_builder(args)
  args = args or {}

  return function(params)
    local path = utils.path.get_current_oil_directory()
    if path == nil then -- No path was provided
      path = "."
    end

    if vim.fn.isdirectory(path) ~= 1 then
      print("Not a directory: " .. path)
      return {}
    end

    return {
      cmd = utils.table.concat_arrays({ { "pytest" }, args, { path, params.args } }),
    }
  end
end

return {
  {
    name = "Pytest file",
    builder = get_pytest_file_builder(),
    desc = "Run pytest on the file opened in the current buffer",
    tags = tags,
    _user_command_nargs = "?",
  },
  {
    name = "Pytest file fast",
    builder = get_pytest_file_builder({ "-m", "not slow" }),
    desc = "Run pytest fast tests on the opened in the current buffer",
    tags = tags,
    _user_command_nargs = "?",
  },
  {
    name = "Pytest file slow",
    builder = get_pytest_file_builder({ "-m", "slow" }),
    tags = tags,
    desc = "Run pytest slow tests on the file openedd in the current buffer",
    _user_command_nargs = "?",
  },
  {
    name = "Pytest directory",
    builder = get_pytest_directory_builder(),
    desc = "Run pytest on the directory opened in Oil buffer or the current working directory",
    tags = tags,
    _user_command_nargs = "?",
  },
  {
    name = "Pytest directory fast",
    builder = get_pytest_directory_builder({ "-m", "not slow" }),
    desc = "Run pytest fast tests on the directory opened in Oil buffer or the current working directory",
    tags = tags,
    _user_command_nargs = "?",
  },
  {
    name = "Pytest directory slow",
    builder = get_pytest_directory_builder({ "-m", "slow" }),
    desc = "Run pytest slow tests on the directory opened in Oil buffer or the current working directory",
    tags = tags,
    _user_command_nargs = "?",
  },
}
