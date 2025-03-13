return {
  name = "python",
  condition = { callback = function(_) return vim.fn.executable("python") == 1 end },
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
        name = "python <file>",
        tags = { "RUN" },
        priority = 1,
        condition = { filetype = "python" },
        builder = function(params)
          return {
            cmd = "python",
            args = vim.list_extend({ vim.fn.expand("%:p:.") }, params.args),
          }
        end,
      }),
      require("overseer").wrap_template(base_template, {
        name = "python -m <module>",
        tags = { "RUN" },
        priority = 2,
        condition = { filetype = "python" },
        builder = function(params)
          return {
            cmd = "python",
            args = vim.list_extend({ "-m", require("lang_utils.python").get_module() }, params.args),
          }
        end,
      }),
    })
  end,
}
