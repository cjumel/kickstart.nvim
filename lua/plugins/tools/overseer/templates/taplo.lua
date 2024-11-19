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
  condition = {
    callback = function(_)
      if vim.fn.executable("taplo") == 0 then
        return false
      end

      -- When installed in Neovim with Mason.nvim, Taplo is always executable, so let's make sure it doesn't always
      -- appear in all the projects by checking if there is any TOML file in the current working directory
      return not vim.tbl_isempty(vim.fs.find(function(name, _) return name:match(".*%.toml$") end, {
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
