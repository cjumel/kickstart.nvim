local python_utils = require("lang_utils.python")

local base_template = {
  params = {
    options = {
      desc = "Options or optional arguments",
      type = "list",
      delimiter = " ", -- Arguments with white spaces (e.g. in "-m 'not slow'") are not working here
      optional = true,
      default = {},
    },
  },
}

return {
  name = "pytest",
  condition = { callback = function(_) return vim.fn.executable("pytest") == 1 end },
  generator = function(_, cb)
    local overseer = require("overseer")

    local is_python_test_file = python_utils.is_test_file()
    local python_test_function_name = nil
    if is_python_test_file then
      python_test_function_name = python_utils.get_test_function_name()
    end

    cb({
      overseer.wrap_template(base_template, {
        name = "pytest",
        tags = { "TEST" },
        builder = function(params)
          return {
            cmd = "pytest",
            args = params.options,
          }
        end,
      }),
      overseer.wrap_template(base_template, {
        name = "pytest <file>",
        tags = { "TEST" },
        condition = { callback = function(_) return is_python_test_file end },
        builder = function(params)
          return {
            cmd = "pytest",
            args = vim.list_extend(params.options, { vim.fn.expand("%:p:~:.") }),
          }
        end,
      }),
      overseer.wrap_template(base_template, {
        name = "pytest <function>",
        tags = { "TEST" },
        condition = { callback = function(_) return python_test_function_name ~= nil end },
        builder = function(params)
          return {
            cmd = "pytest",
            args = vim.list_extend(params.options, { vim.fn.expand("%:p:~:.") .. "::" .. python_test_function_name }),
          }
        end,
      }),
    })
  end,
}
