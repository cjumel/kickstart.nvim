local template_builder = require("plugins.tools.overseer.template_builder")

local cmd = "pytest"
local opts = {
  condition_callback = function(_) return vim.fn.executable("pytest") == 1 end,
  filetype = "python",
  has_args = true,
  default_args = { "-m", "not slow" },
}

return {
  template_builder.cmd(cmd, opts),
  template_builder.cmd_dir(cmd, opts),
  template_builder.cmd_file(cmd, opts),
}
