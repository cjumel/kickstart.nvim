local nvim_config = require("nvim_config")

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
  condition = {
    callback = function(_)
      if vim.fn.executable("ruff") == 0 then
        return false
      end

      -- When installed in Neovim with Mason.nvim, Ruff is always executable, so let's make sure it doesn't always
      -- appear in all the projects by making sure we're in a Python project or there are Python files in the current
      -- working directory
      return nvim_config.project_type_markers_callback["python"]()
        or not vim.tbl_isempty(vim.fs.find(function(name, _) return name:match(".*%.py$") end, {
          type = "file",
          path = vim.fn.getcwd(),
          upward = true, -- Otherwise this doesn't work
          stop = vim.fn.getcwd(),
        }))
    end,
  },
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
