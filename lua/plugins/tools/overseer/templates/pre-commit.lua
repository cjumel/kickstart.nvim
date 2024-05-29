local template_builder = require("plugins.tools.overseer.template_builder")

local opts = {
  condition_callback = function(_)
    -- Find the root of the Git repository containing the current project
    local git_dir_path = vim.fn.finddir(".git", vim.fn.getcwd() .. ";")
    if git_dir_path == "" then -- ".git" directory not found
      return false
    end
    local repository_root_path = vim.fn.fnamemodify(git_dir_path, ":h") -- Parent directory of ".git/"

    return vim.fn.filereadable(repository_root_path .. "/.pre-commit-config.yaml") == 1
  end,
  filetype = "all",
}

return {
  template_builder.cmd({ "pre-commit", "run", "--all-files" }, opts),
  template_builder.cmd_file({ "pre-commit", "run", "--file" }, opts),
}
