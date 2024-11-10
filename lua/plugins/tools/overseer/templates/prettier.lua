local path_utils = require("path_utils")

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

      -- When installed in Neovim with Mason.nvim, Prettier is always executable, so let's add a smarter condition to
      -- make sure it doesn't always appear in all the projects: look for any Prettier configuration file

      local root_path = path_utils.get_project_root(":p")
      local potential_prettier_config_file_names = {
        ".prettierrc",
        ".prettierrc.json",
        ".prettierrc.yml",
        ".prettierrc.yaml",
        ".prettierrc.json5",
        ".prettierrc.toml",
        ".prettierignore",
      }
      for _, config_file_name in ipairs(potential_prettier_config_file_names) do
        if vim.fn.filereadable(root_path .. config_file_name) == 1 then
          return true
        end
      end

      return false
    end,
  },
  generator = function(_, cb)
    local overseer = require("overseer")

    cb({
      overseer.wrap_template(base_template, {
        name = "prettier <cwd>",
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
