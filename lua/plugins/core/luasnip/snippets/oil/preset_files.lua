local oil_snippets = require("plugins.core.luasnip.reusable-snippets.oil")

local filetype_to_preset_files = {
  lua = {
    "init.lua",
    "scratch.lua",
  },
  markdown = {
    "README.md",
  },
  norg = {
    "notes.norg",
    "todo.norg",
  },
  python = {
    "__init__.py",
    "scratch.py",
  },
}

local snippets = {}
for filetype, preset_files in pairs(filetype_to_preset_files) do
  for _, snippet in
    ipairs(oil_snippets.get_simple_file_snippets(preset_files, { project_type = filetype }))
  do
    table.insert(snippets, snippet)
  end
end

return snippets
