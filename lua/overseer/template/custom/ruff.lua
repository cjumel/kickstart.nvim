-- Complete ruff LSP setup to support:
--  - file check fixes (not enabled on format-on-save with my LSP setup)
--  - unsafe check fixes
--  - formatting/check fixing the entire project (e.g. after a batch edition when format-on-save is not enabled)

return {
  name = "ruff",
  condition = {
    callback = function(_)
      if vim.fn.executable("ruff") == 0 then
        return false
      end
      local python_utils = require("config.lang_utils.python")
      return python_utils.is_project()
    end,
  },
  generator = function(_, cb)
    local overseer = require("overseer")
    local base_template = {
      params = {
        args = {
          type = "list",
          delimiter = " ",
          optional = true,
          default = {},
        },
      },
    }
    cb({
      overseer.wrap_template(base_template, {
        name = "ruff format <file>",
        tags = { "FORMAT" },
        priority = 1,
        condition = { filetype = "python" },
        builder = function(params)
          return {
            cmd = { "ruff", "format" },
            args = vim.list_extend({ vim.fn.expand("%:p:.") }, params.args),
          }
        end,
      }),
      overseer.wrap_template(base_template, {
        name = "ruff format",
        tags = { "FORMAT" },
        priority = 2,
        builder = function(params)
          return {
            cmd = { "ruff", "format" },
            args = params.args,
          }
        end,
      }),
      overseer.wrap_template(base_template, {
        name = "ruff check --fix <file>",
        tags = { "CHECK" },
        priority = 1,
        condition = { filetype = "python" },
        builder = function(params)
          return {
            cmd = { "ruff", "check", "--fix" },
            args = vim.list_extend({ vim.fn.expand("%:p:.") }, params.args),
          }
        end,
      }),
      overseer.wrap_template(base_template, {
        name = "ruff check --fix --unsafe-fixes <file>",
        tags = { "CHECK" },
        priority = 2,
        condition = { filetype = "python" },
        builder = function(params)
          return {
            cmd = { "ruff", "check", "--fix", "--unsafe-fixes" },
            args = vim.list_extend({ vim.fn.expand("%:p:.") }, params.args),
          }
        end,
      }),
      overseer.wrap_template(base_template, {
        name = "ruff check --fix",
        tags = { "CHECK" },
        priority = 3,
        builder = function(params)
          return {
            cmd = { "ruff", "check", "--fix" },
            args = params.args,
          }
        end,
      }),
      overseer.wrap_template(base_template, {
        name = "ruff check --fix --unsafe-fixes",
        tags = { "CHECK" },
        priority = 4,
        builder = function(params)
          return {
            cmd = { "ruff", "check", "--fix", "--unsafe-fixes" },
            args = params.args,
          }
        end,
      }),
    })
  end,
}
