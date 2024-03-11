local oil_snippets = require("plugins.core.luasnip.reusable-snippets.oil")
local utils = require("utils")

local filetype = "markdown"
local extension = "md"
local simple_file_names = {
  "README.md",
}

return utils.table.concat_arrays({
  { oil_snippets.get_filetype_snippet(filetype, extension) },
  oil_snippets.get_simple_file_snippets(simple_file_names, { project_type = filetype }),
})
