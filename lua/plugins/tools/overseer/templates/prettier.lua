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
  condition = {
    callback = function(_)
      if vim.fn.executable("prettier") == 0 then
        return false
      end

      -- When installed in Neovim with Mason.nvim, Prettier is always executable, so let's make sure it doesn't always
      -- appear in all the projects by checking if there is a file with a relevant filetype in the current working
      -- directory
      return not vim.tbl_isempty(
        vim.fs.find(
          function(name, _)
            return name:match(".*%.json$")
              or name:match(".*%.jsonc$")
              or name:match(".*%.md$")
              or name:match(".*%.yaml$")
              or name:match(".*%.yml$")
          end,
          {
            type = "file",
            path = vim.fn.getcwd(),
            upward = true, -- Otherwise this doesn't work
            stop = vim.fn.getcwd(),
          }
        )
      )
    end,
  },
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
