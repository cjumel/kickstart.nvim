-- There is a builtin template for cargo, but it adds too many things to my taste, and it doesn't use some tags that I
-- use, so I prefer re-implementing a simpler version of it

return {
  name = "cargo",
  condition = {
    callback = function(_)
      if vim.fn.executable("cargo") == 0 then
        return false
      end
      local rust_utils = require("config.lang_utils.rust")
      return rust_utils.is_project()
    end,
  },
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
        name = "cargo check",
        tags = { "CHECK" },
        builder = function(params)
          return {
            cmd = { "cargo", "check" },
            args = params.args,
          }
        end,
      }),
      require("overseer").wrap_template(base_template, {
        name = "cargo build",
        tags = { "BUILD" },
        builder = function(params)
          return {
            cmd = { "cargo", "build" },
            args = params.args,
          }
        end,
      }),
      require("overseer").wrap_template(base_template, {
        name = "cargo run",
        tags = { "RUN" },
        builder = function(params)
          return {
            cmd = { "cargo", "run" },
            args = params.args,
          }
        end,
      }),
    })
  end,
}
