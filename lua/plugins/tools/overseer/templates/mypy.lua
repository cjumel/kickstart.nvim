local template_builder = require("plugins.tools.overseer.template_builder")

local cmd = "mypy"
local opts = {
  condition_callback = function(_) return vim.fn.executable("mypy") == 1 end,
  filetype = "python",
  has_args = true,
  default_args = { "--strict", "--install-types", "--non-interactive" },
}

return {
  template_builder.cmd_cwd(cmd, opts),
  template_builder.cmd_dir(cmd, opts),
  template_builder.cmd_file(cmd, opts),
}
