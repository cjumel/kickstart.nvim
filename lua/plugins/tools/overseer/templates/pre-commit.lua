--- Output the root path of the Git repository containing the directory whose path is provided, or nil if there is none.
---@param dir_path string|nil The path of a directory (default to the cwd).
---@param mods string|nil The modifiers to apply to the output path.
---@return string|nil
local function get_git_root(dir_path, mods)
  dir_path = dir_path or vim.fn.getcwd()

  -- Find the path of a ".git" directory in the target directory or any of its ancestors
  local dot_git_dir_path = vim.fn.finddir(".git", dir_path .. ";")
  if dot_git_dir_path == "" then -- ".git" directory not found
    return
  end

  local git_root_path = vim.fn.fnamemodify(dot_git_dir_path, ":h") -- Parent directory of ".git/"
  if mods then
    git_root_path = vim.fn.fnamemodify(git_root_path, mods)
  end
  return git_root_path
end

return {
  name = "pre-commit",
  condition = {
    callback = function(_)
      if vim.fn.executable("pre-commit") == 0 then
        return false
      end
      local git_root_path = get_git_root()
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
        builder = function(_)
          return {
            cmd = { "pre-commit", "run" },
            args = { "--all-files" },
          }
        end,
      },
      {
        name = "pre-commit run --files <file>",
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
