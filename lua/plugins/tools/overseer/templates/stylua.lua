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
  name = "stylua",
  condition = {
    callback = function(_)
      if vim.fn.executable("stylua") == 0 then
        return false
      end

      -- When installed in Neovim with Mason.nvim, Stylua is always executable, so let's make sure it doesn't always
      -- appear in all the projects by making sure we're in a Lua project or there are Lua files in the current working
      -- directory
      return nvim_config.project_type_markers_callback["lua"]()
        or not vim.tbl_isempty(vim.fs.find(function(name, _)
          -- Exclude the special case of custom Neovim config files, as it doesn't mean there will be other Lua files
          return name:match(".*%.lua$") and name ~= ".nvim.lua"
        end, {
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
        name = "stylua <cwd>",
        tags = { "FORMAT" },
        builder = function(params)
          return {
            cmd = { "stylua" },
            args = vim.list_extend(params.options, { "." }),
          }
        end,
      }),
    })
  end,
}
