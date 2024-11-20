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
  name = "stylua",
  condition = { callback = function(_) return vim.fn.executable("stylua") == 1 end },
  generator = function(_, cb)
    local overseer = require("overseer")
    cb({
      overseer.wrap_template(base_template, {
        name = "stylua <cwd>",
        tags = { "FORMAT" },
        builder = function(params)
          return {
            cmd = { "stylua" },
            args = vim.list_extend(params.options, { "." }),
          }
        end,
      }),
    })
  end,
}
