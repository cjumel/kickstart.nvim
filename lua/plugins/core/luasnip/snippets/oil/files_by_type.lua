local oil_snippets = require("plugins.core.luasnip.reusable-snippets.oil")

-- extension can be set to null with 1-item lists
local filetypes_and_extensions = {
  { "lua" },
  { "markdown", "md" },
  { "norg" },
  { "python", "py" },
}

local snippets = {}
for _, filetype_and_extension in ipairs(filetypes_and_extensions) do
  local snippet =
    oil_snippets.get_filetype_snippet(filetype_and_extension[1], filetype_and_extension[2])
  table.insert(snippets, snippet)
end

return snippets
