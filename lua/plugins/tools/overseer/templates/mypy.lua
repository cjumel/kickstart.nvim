local base_template = {
  params = {
    args = {
      type = "list",
      delimiter = " ",
      optional = true,
      default = { "--strict", "--install-types", "--non-interactive" },
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
        builder = function(params)
          local path = "."
          return {
            cmd = "mypy",
            args = vim.list_extend(params.args or {}, { path }),
          }
        end,
      }, nil),
      overseer.wrap_template(base_template, {
        name = "mypy <file>",
        condition = { filetype = "python" },
        builder = function(params)
          local path = vim.fn.expand("%:p:~:.") -- Current file path relative to cwd or HOME or absolute
          return {
            cmd = "mypy",
            args = vim.list_extend(params.args or {}, { path }),
          }
        end,
      }, nil),
      overseer.wrap_template(base_template, {
        name = "mypy <dir>",
        condition = { filetype = "oil" },
        builder = function(params)
          local path = package.loaded.oil.get_current_dir()
          path = vim.fn.fnamemodify(path, ":p:~:.") -- Make path relative to cwd or HOME or absolute
          return {
            cmd = "mypy",
            args = vim.list_extend(params.args or {}, { path }),
          }
        end,
      }, nil),
    })
  end,
}
