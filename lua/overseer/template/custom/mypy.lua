return {
  name = "mypy",
  condition = { callback = function(_) return vim.fn.executable("mypy") == 1 end },
  generator = function(_, cb)
    local overseer = require("overseer")
    local base_template = {
      tags = { "CHECK" },
      params = {
        args = {
          desc = "Additional arguments",
          type = "list",
          delimiter = " ",
          optional = true,
          default = {},
        },
      },
    }
    cb({
      overseer.wrap_template(base_template, {
        name = "mypy <file>",
        priority = 1,
        condition = { filetype = "python" },
        builder = function(params)
          local path = vim.fn.expand("%:p:.")
          return { cmd = "mypy", args = vim.list_extend({ path }, params.args) }
        end,
      }),
      overseer.wrap_template(base_template, {
        name = "mypy <dir>",
        priority = 1,
        condition = { filetype = "oil" },
        builder = function(params)
          local path = vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p:.")
          return { cmd = "mypy", args = vim.list_extend({ path }, params.args) }
        end,
      }),
      overseer.wrap_template(base_template, {
        name = "mypy <cwd>",
        priority = 2,
        builder = function(params)
          local path = "."
          return { cmd = "mypy", args = vim.list_extend({ path }, params.args) }
        end,
      }),
    })
  end,
}
