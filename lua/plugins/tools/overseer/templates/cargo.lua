-- There is a builtin template for cargo, but it adds too many things to my taste, and it doesn't use some tags that I
-- use, so I prefer re-implementing a simpler version of it

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

return {
  name = "cargo",
  condition = {
    callback = function(_)
      if vim.fn.executable("cargo") == 0 then
        return false
      end

      return not vim.tbl_isempty(vim.fs.find("Cargo.toml", {
        type = "file",
        path = vim.fn.getcwd(),
        upward = true, -- Search in the current directory and its ancestors
        stop = vim.env.HOME,
      }))
    end,
  },
  generator = function(_, cb)
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
