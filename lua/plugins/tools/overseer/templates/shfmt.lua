local nvim_config = require("nvim_config")

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
  condition = {
    callback = function(_)
      if vim.fn.executable("shfmt") == 0 then
        return false
      end

      -- When installed in Neovim with Mason.nvim, shfmt is always executable, so let's make sure it doesn't always
      -- appear in all the projects by making sure we're in a zsh project or there are zsh files in the current
      -- working directory
      return nvim_config.project_type_markers_callback["zsh"]()
        or not vim.tbl_isempty(vim.fs.find(function(name, _) return name:match(".*%.zsh$") end, {
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
