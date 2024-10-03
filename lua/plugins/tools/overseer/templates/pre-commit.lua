return {
  name = "pre-commit run",
  condition = {
    callback = function(_)
      if vim.fn.executable("pre-commit") == 0 then
        return false
      end
      local git_root_path = require("cwd").get_git_root()
      if git_root_path == nil then
        return false
      end
      if vim.fn.filereadable(git_root_path .. "/.pre-commit-config.yaml") == 0 then
        return false
      end
      return true
    end,
  },
  generator = function(_, cb)
    cb({
      {
        name = "pre-commit run --all-files",
        builder = function(_)
          return {
            cmd = { "pre-commit", "run" },
            args = { "--all-files" },
          }
        end,
      },
      {
        name = "pre-commit run --files <file>",
        condition = { callback = function(_) return not require("buffer").is_temporary() end },
        builder = function(_)
          local path = vim.fn.expand("%:p:~:.") -- Current file path relative to cwd or HOME or absolute
          return {
            cmd = { "pre-commit", "run" },
            args = { "--files", path },
          }
        end,
      },
    })
  end,
}
