local path_utils = require("path_utils")

local base_template = {
  params = {
    options = {
      desc = "Options or optional arguments",
      type = "list",
      delimiter = " ",
      optional = true,
      default = {},
    },
  },
}

return {
  name = "ruff",
  condition = {
    callback = function(_)
      return vim.fn.executable("ruff") == 1
        -- Add a condition on the presence of Python files in the project, as, when installed with Mason.nvim,
        -- Ruff is always executable
        and not vim.tbl_isempty(vim.fs.find(function(name, _) return name:match(".*%.py$") end, {
          type = "file",
          path = vim.fn.expand("%"),
          upward = true,
          stop = path_utils.get_project_root(),
        }))
    end,
  },
  generator = function(_, cb)
    local overseer = require("overseer")
    cb({
      overseer.wrap_template(base_template, {
        name = "ruff check",
        builder = function(params)
          return {
            cmd = { "ruff", "check" },
            args = params.options,
          }
        end,
      }),
      overseer.wrap_template({
        name = "ruff format",
        builder = function(params)
          return {
            cmd = { "ruff", "format" },
            args = params.options,
          }
        end,
      }),
    })
  end,
}
