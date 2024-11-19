local base_template = {
  params = {
    options = {
      desc = "Options or optional arguments (e.g. --strict)",
      type = "list",
      delimiter = " ",
      optional = true,
      default = {},
    },
  },
}

return {
  name = "mypy",
  condition = { callback = function(_) return vim.fn.executable("mypy") == 1 end },
  generator = function(_, cb)
    local overseer = require("overseer")
    cb({
      overseer.wrap_template(base_template, {
        name = "mypy <cwd>",
        tags = { "CHECK" },
        builder = function(params)
          return {
            cmd = "mypy",
            args = vim.list_extend(params.options, { "." }),
          }
        end,
      }),
      overseer.wrap_template(base_template, {
        name = "mypy <file>",
        tags = { "CHECK" },
        condition = { filetype = "python" },
        builder = function(params)
          return {
            cmd = "mypy",
            args = vim.list_extend(params.options, { vim.fn.expand("%:p:~:.") }),
          }
        end,
      }),
    })
  end,
}
