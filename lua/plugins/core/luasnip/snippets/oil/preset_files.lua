local ls = require("luasnip")
local show_conds = require("luasnip.extras.conditions.show")

local custom_conds = require("plugins.core.luasnip.conditions")

local s = ls.snippet
local t = ls.text_node

-- Define here the preset files for each file type
-- Some file types (e.g. Python & Lua) whill be associated with a condition on the project content
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

-- Build the snippets
local snippets = {}
for filetype, preset_files in pairs(filetype_to_preset_files) do
  local show_condition = custom_conds.ts.line_begin * show_conds.line_end
  if filetype == "python" then
    show_condition = show_condition * custom_conds.project.is_python
  elseif filetype == "lua" then
    show_condition = show_condition * custom_conds.project.is_lua
  end

  for _, file_name in ipairs(preset_files) do
    local snippet = s({
      trig = file_name,
      show_condition = show_condition * custom_conds.oil.file_not_exists(file_name),
    }, { t(file_name) })
    table.insert(snippets, snippet)
  end
end

return snippets
