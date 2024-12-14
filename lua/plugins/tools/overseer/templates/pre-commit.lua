return {
  name = "pre-commit",
  condition = {
    callback = function(_)
      if vim.fn.executable("pre-commit") == 0 then
        return false
      end
      local git_root_path = require("snacks").git.get_root(vim.fn.getcwd())
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
    cb({
      {
        name = "pre-commit run --all-files",
        tags = { "CHECK", "FORMAT" },
        builder = function(_)
          return {
            cmd = { "pre-commit", "run" },
            args = { "--all-files" },
          }
        end,
      },
      {
        name = "pre-commit run --files <file>",
        tags = { "CHECK", "FORMAT" },
        condition = { callback = function(_) return vim.bo.buftype == "" end },
        builder = function(_)
          return {
            cmd = { "pre-commit", "run" },
            args = { "--files", vim.fn.expand("%:p:~:.") },
          }
        end,
      },
    })
  end,
}
