return {
  name = "mypy",
  condition = { callback = function(_) return vim.fn.executable("mypy") == 1 end },
  generator = function(_, cb)
    local base_template = {
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
      require("overseer").wrap_template(base_template, {
        name = "mypy <cwd>",
        tags = { "CHECK" },
        priority = 2,
        builder = function(params)
          return {
            cmd = "mypy",
            args = vim.list_extend({ "." }, params.args),
          }
        end,
      }),
      require("overseer").wrap_template(base_template, {
        name = "mypy <file>",
        tags = { "CHECK" },
        priority = 1,
        condition = { filetype = "python" },
        builder = function(params)
          return {
            cmd = "mypy",
            args = vim.list_extend({ vim.fn.expand("%:p:.") }, params.args),
          }
        end,
      }),
    })
  end,
}
