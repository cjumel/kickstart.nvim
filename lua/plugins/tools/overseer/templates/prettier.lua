local base_template = {
  params = {
    options = {
      desc = "Options or optional arguments",
      type = "list",
      delimiter = " ",
      optional = true,
      default = { "--write" },
    },
  },
}

return {
  name = "prettier",
  condition = { callback = function(_) return vim.fn.executable("prettier") == 1 end },
  generator = function(_, cb)
    local overseer = require("overseer")

    cb({
      overseer.wrap_template(base_template, {
        name = "prettier --write <cwd>",
        tags = { "FORMAT" },
        builder = function(params)
          return {
            cmd = { "prettier" },
            args = vim.list_extend(params.options, { "." }),
          }
        end,
      }),
    })
  end,
}
