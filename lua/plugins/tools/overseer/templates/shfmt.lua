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
  name = "shfmt",
  condition = { callback = function(_) return vim.fn.executable("shfmt") == 1 end },
  generator = function(_, cb)
    local overseer = require("overseer")
    cb({
      overseer.wrap_template(base_template, {
        name = "shfmt --write <cwd>",
        tags = { "FORMAT" },
        builder = function(params)
          return {
            cmd = { "shfmt" },
            args = vim.list_extend(params.options, { "." }),
          }
        end,
      }),
    })
  end,
}
