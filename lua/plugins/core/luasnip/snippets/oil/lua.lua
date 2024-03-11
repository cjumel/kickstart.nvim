local ls_utils = require("plugins.core.luasnip.utils")

return ls_utils.oil.make_oil_file_snippets({
  "init.lua",
  "scratch.lua",
}, { project_type = "lua" })
