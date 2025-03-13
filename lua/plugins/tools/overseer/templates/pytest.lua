return {
  name = "pytest",
  condition = { callback = function(_) return vim.fn.executable("pytest") == 1 end },
  generator = function(_, cb)
    local base_template = {
      params = {
        args = {
          desc = "Additional arguments",
          type = "list",
          delimiter = " ", -- Arguments with white spaces (e.g. in "-m 'not slow'") are not supported
          optional = true,
          default = {},
        },
      },
    }
    local is_python_test_file = require("lang_utils.python").is_test_file()
    local python_test_function_name = nil
    if is_python_test_file then
      python_test_function_name = require("lang_utils.python").get_test_function_name()
    end
    cb({
      require("overseer").wrap_template(base_template, {
        name = "pytest",
        tags = { "TEST" },
        builder = function(params)
          return {
            cmd = "pytest",
            args = params.args,
          }
        end,
      }),
      require("overseer").wrap_template(base_template, {
        name = "pytest <file>",
        tags = { "TEST" },
        condition = { callback = function() return is_python_test_file end },
        builder = function(params)
          return {
            cmd = "pytest",
            args = vim.list_extend({ vim.fn.expand("%:p:.") }, params.args),
          }
        end,
      }),
      require("overseer").wrap_template(base_template, {
        name = "pytest <function>",
        tags = { "TEST" },
        condition = { callback = function() return python_test_function_name ~= nil end },
        builder = function(params)
          return {
            cmd = "pytest",
            args = vim.list_extend({ vim.fn.expand("%:p:.") .. "::" .. python_test_function_name }, params.args),
          }
        end,
      }),
    })
  end,
}
