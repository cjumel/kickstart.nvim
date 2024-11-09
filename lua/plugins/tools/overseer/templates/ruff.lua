local path_utils = require("path_utils")

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

      -- When installed in Neovim with Mason.nvim, Ruff is always executable, so let's add a smarter condition to make
      -- sure it doesn't always appear in all the projects: look for any potential Ruff configuration file, or any
      -- Python file in the current project (or an approximation of this)

      local root_path = path_utils.get_project_root(":p")
      local potential_ruff_config_file_names = { "pyproject.toml", "ruff.toml", ".ruff.toml" }
      for _, config_file_name in ipairs(potential_ruff_config_file_names) do
        if vim.fn.filereadable(root_path .. config_file_name) == 1 then
          return true
        end
      end

      local current_path = nil
      if vim.bo.buftype == "" and vim.bo.filetype ~= "" then -- A regular buffer is opened
        current_path = vim.fn.expand("%")
      elseif vim.bo.filetype == "oil" then -- An Oil buffer is opened
        current_path = require("oil").get_current_dir()
      end
      if
        current_path ~= nil
        and not vim.tbl_isempty(vim.fs.find(function(name, _) return name:match(".*%.py$") end, {
          type = "file",
          path = current_path,
          upward = true,
          stop = root_path,
        }))
      then
        return true
      end

      return false
    end,
  },
  generator = function(_, cb)
    local overseer = require("overseer")
    cb({
      overseer.wrap_template(base_template, {
        name = "ruff check",
        builder = function(params)
          return {
            cmd = { "ruff", "check" },
            args = params.options,
          }
        end,
      }),
      overseer.wrap_template({
        name = "ruff format",
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
