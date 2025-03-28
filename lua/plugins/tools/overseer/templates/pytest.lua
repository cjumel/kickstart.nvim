return {
  name = "pytest",
  condition = { callback = function(_) return vim.fn.executable("pytest") == 1 end },
  generator = function(_, cb)
    local python_utils = require("lang_utils.python")
    local overseer = require("overseer")

    local base_template = {
      tags = { "TEST" },
      params = {
        args = {
          desc = 'Additional arguments (e.g. "-vv", "--lf")',
          type = "list",
          delimiter = " ", -- Arguments with white spaces (e.g. in "-m 'not slow'") are not supported
          optional = true,
          default = {},
        },
      },
    }

    local is_test_file = python_utils.is_test_file()
    local test_function_name = is_test_file and python_utils.get_test_function_name() or nil
    local is_test_dir = python_utils.is_test_dir()

    cb({
      overseer.wrap_template(base_template, {
        name = "pytest <function>",
        priority = 1,
        condition = { callback = function() return test_function_name ~= nil end },
        builder = function(params)
          local path = vim.fn.expand("%:p:.") .. "::" .. test_function_name
          return { cmd = "pytest", args = vim.list_extend({ path }, params.args) }
        end,
      }),
      overseer.wrap_template(base_template, {
        name = "pytest <file>",
        condition = { callback = function() return is_test_file end },
        priority = 2,
        builder = function(params)
          local path = vim.fn.expand("%:p:.")
          return { cmd = "pytest", args = vim.list_extend({ path }, params.args) }
        end,
      }),
      overseer.wrap_template(base_template, {
        name = "pytest <dir>",
        condition = { callback = function() return is_test_dir end },
        priority = 2,
        builder = function(params)
          local path = vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p:.")
          return { cmd = "pytest", args = vim.list_extend({ path }, params.args) }
        end,
      }),
      overseer.wrap_template(base_template, {
        name = "pytest",
        priority = 3,
        builder = function(params) return { cmd = "pytest", args = params.args } end,
      }),
    })
  end,
}
