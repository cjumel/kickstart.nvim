local utils = require("utils")

local arguments = require("plugins.external_tools.overseer.arguments")

local function get_pytest_builder(opts)
  opts = opts or {}
  local extra_args = opts.extra_args or {}

  return function(params)
    local arguments_path = arguments.get_path(params)

    if vim.fn.filereadable(arguments_path) == 1 or vim.fn.isdirectory(arguments_path) == 1 then
      return {
        cmd = utils.table.concat_arrays({ { "pytest" }, extra_args, { arguments_path } }),
      }
    else
      print("Not a readable file or a directory: " .. arguments_path)
      return {}
    end
  end
end

return {
  {
    name = "Pytest",
    tags = { "python", "pytest" },
    builder = get_pytest_builder(),
    _user_command_nargs = "?",
  },
  {
    name = "Pytest fast",
    tags = { "python", "pytest" },
    builder = get_pytest_builder({ extra_args = { "-m", "'not slow'" } }),
    _user_command_nargs = "?",
  },
  {
    name = "Pytest slow",
    tags = { "python", "pytest" },
    builder = get_pytest_builder({ extra_args = { "-m", "'slow'" } }),
    _user_command_nargs = "?",
  },
}
