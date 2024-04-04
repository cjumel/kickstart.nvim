local utils = require("utils")

return utils.table.concat_arrays({
  require("plugins.tools.overseer.templates.luajit"),
  require("plugins.tools.overseer.templates.make"),
  require("plugins.tools.overseer.templates.mypy"),
  require("plugins.tools.overseer.templates.poetry"),
  require("plugins.tools.overseer.templates.pre-commit"),
  require("plugins.tools.overseer.templates.pytest"),
  require("plugins.tools.overseer.templates.python"),
})
