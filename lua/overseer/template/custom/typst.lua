return {
  name = "typst",
  condition = { callback = function(_) return vim.fn.executable("typst") == 1 end },
  generator = function(_, cb)
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
      require("overseer").wrap_template(base_template, {
        name = "typst compile",
        tags = { "BUILD" },
        priority = 1,
        condition = { filetype = "typst" },
        builder = function(params)
          return {
            cmd = { "typst", "compile" },
            args = vim.list_extend({ vim.fn.expand("%:p:.") }, params.args),
          }
        end,
      }),
      require("overseer").wrap_template(base_template, {
        name = "typst watch",
        tags = { "BUILD" },
        priority = 2,
        condition = { filetype = "typst" },
        builder = function(params)
          return {
            cmd = { "typst", "watch" },
            args = vim.list_extend({ vim.fn.expand("%:p:.") }, params.args),
          }
        end,
      }),
    })
  end,
}
