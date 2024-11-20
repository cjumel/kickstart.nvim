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
  name = "taplo",
  condition = { callback = function(_) return vim.fn.executable("taplo") == 1 end },
  generator = function(_, cb)
    local overseer = require("overseer")
    cb({
      overseer.wrap_template(base_template, {
        name = "taplo format",
        tags = { "FORMAT" },
        builder = function(params)
          return {
            cmd = { "taplo", "format" },
            args = params.options,
          }
        end,
      }),
    })
  end,
}
