local oil_snippets = require("plugins.core.luasnip.reusable-snippets.oil")
local utils = require("utils")

local filetype = "lua"
local simple_file_names = {
  "init.lua",
  "scratch.lua",
}

return utils.table.concat_arrays({
  { oil_snippets.get_filetype_snippet(filetype) },
  oil_snippets.get_simple_file_snippets(simple_file_names, { project_type = filetype }),
})
