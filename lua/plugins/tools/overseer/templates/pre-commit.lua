return {
  name = "pre-commit",
  condition = {
    callback = function(_)
      if vim.fn.executable("pre-commit") == 0 then
        return false
      end
      local dir_path = vim.fn.getcwd() .. "/.git" -- Without "/.git", the git root path detection below won't work
      local git_root_path = Snacks.git.get_root(dir_path)
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
    cb({
      require("overseer").wrap_template(base_template, {
        name = "pre-commit run --all-files",
        tags = { "CHECK" },
        priority = 2,
        builder = function(params)
          return {
            cmd = { "pre-commit", "run" },
            args = vim.list_extend({ "--all-files" }, params.args),
          }
        end,
      }),
      require("overseer").wrap_template(base_template, {
        name = "pre-commit run --files <file>",
        tags = { "CHECK" },
        priority = 1,
        condition = { callback = function(_) return vim.bo.buftype == "" end },
        builder = function(params)
          return {
            cmd = { "pre-commit", "run" },
            args = vim.list_extend({ "--files", vim.fn.expand("%:p:.") }, params.args),
          }
        end,
      }),
    })
  end,
}
