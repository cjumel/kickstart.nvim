local oil_snippets = require("plugins.core.luasnip.reusable-snippets.oil")
local utils = require("utils")

local filetype = "python"
local extension = "py"
local simple_file_names = {
  "__init__.py",
  "scratch.py",
}

return utils.table.concat_arrays({
  { oil_snippets.get_filetype_snippet(filetype, extension) },
  oil_snippets.get_simple_file_snippets(simple_file_names, { project_type = filetype }),
})
