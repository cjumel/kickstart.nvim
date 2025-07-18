return {
  name = "pre-commit",
  condition = {
    callback = function(_)
      if vim.fn.executable("pre-commit") == 0 then
        return false
      end
      local git_root_path = Snacks.git.get_root(vim.fn.getcwd())
      if git_root_path == nil then -- Not in a Git repository
        return false
      end
      if vim.fn.filereadable(git_root_path .. "/.pre-commit-config.yaml") == 0 then -- No pre-commit config file
        return false
      end
      return true
    end,
  },
  generator = function(_, cb)
    local overseer = require("overseer")
    local base_template = {
      tags = { "CHECK" },
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
    cb({
      overseer.wrap_template(base_template, {
        name = "pre-commit run --files <file>",
        priority = 1,
        condition = { callback = function(_) return vim.bo.buftype == "" end },
        builder = function(params)
          local path = vim.fn.expand("%:p:.")
          return { cmd = { "pre-commit", "run" }, args = vim.list_extend({ "--files", path }, params.args) }
        end,
      }),
      overseer.wrap_template(base_template, {
        name = "pre-commit run --files <dir>/**/*",
        priority = 1,
        condition = { filetype = "oil" },
        builder = function(params)
          local path = vim.fn.fnamemodify(require("oil").get_current_dir() --[[@as string]], ":p:.")
          local files = vim.fn.glob(path .. "**/*", false, true)
          local valid_files = {}
          for _, file in ipairs(files) do
            if vim.fn.filereadable(file) == 1 then
              table.insert(valid_files, file)
            end
          end
          return {
            name = "pre-commit run --files " .. path .. "**/*",
            cmd = { "pre-commit", "run" },
            args = vim.list_extend({ "--files" }, vim.list_extend(valid_files, params.args)),
          }
        end,
      }),
      overseer.wrap_template(base_template, {
        name = "pre-commit run --all-files",
        priority = 2,
        builder = function(params)
          return { cmd = { "pre-commit", "run" }, args = vim.list_extend({ "--all-files" }, params.args) }
        end,
      }),
    })
  end,
}
