local utils = require("utils")
local template_builder = require("plugins.tools.overseer.template_builder")

local opts = {
  condition_callback = function(_)
    local git_root_path = utils.path.get_git_root()
    if git_root_path == nil then
      return false
    end

    return vim.fn.filereadable(git_root_path .. "/.pre-commit-config.yaml") == 1
  end,
  filetype = "all",
}

return {
  template_builder.cmd({ "pre-commit", "run", "--all-files" }, opts),
  template_builder.cmd_file({ "pre-commit", "run", "--file" }, opts),
}
