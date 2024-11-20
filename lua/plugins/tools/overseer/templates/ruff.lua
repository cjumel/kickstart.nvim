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
  condition = { callback = function(_) return vim.fn.executable("ruff") == 1 end },
  generator = function(_, cb)
    local overseer = require("overseer")
    cb({
      overseer.wrap_template(base_template, {
        name = "ruff check",
        tags = { "CHECK" },
        builder = function(params)
          return {
            cmd = { "ruff", "check" },
            args = params.options,
          }
        end,
      }),
      overseer.wrap_template(base_template, {
        name = "ruff format",
        tags = { "FORMAT" },
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
