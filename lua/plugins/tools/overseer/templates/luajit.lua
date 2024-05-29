local template_builder = require("plugins.tools.overseer.template_builder")

return {
  template_builder.cmd_file("luajit", { filetype = "lua" }),
}
