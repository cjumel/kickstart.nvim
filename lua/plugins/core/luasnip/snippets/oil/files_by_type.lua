local events = require("luasnip.util.events")
local ls = require("luasnip")
local show_conds = require("luasnip.extras.conditions.show")

local custom_conds = require("plugins.core.luasnip.conditions")

local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

-- Define here the file types for which to create a snippet
-- Extension can be set to null with 1-item lists (meaning the extension is the same as the file
-- type)
-- Some file types (e.g. Python & Lua) whill be associated with a condition on the project content
local filetypes_and_extensions = {
  { "lua" },
  { "markdown", "md" },
  { "norg" },
  { "python", "py" },
}

local callbacks = {
  [-1] = { -- -1 is for the whole snippet
    [events.leave] = function(_, _)
      vim.cmd("stopinsert")
      require("oil").save()
    end,
  },
}

-- Directory snippet
local snippets = {
  s(
    { trig = "directory", show_condition = custom_conds.ts.line_begin * show_conds.line_end },
    { i(1, "name"), t("/") },
    { callbacks = callbacks }
  ),
}

-- File type snippets
for _, filetype_and_extension in ipairs(filetypes_and_extensions) do
  local filetype = filetype_and_extension[1]
  local extension = filetype_and_extension[2] or filetype

  local show_condition = custom_conds.ts.line_begin * show_conds.line_end
  if filetype == "python" then
    show_condition = show_condition * custom_conds.project.is_python
  elseif filetype == "lua" then
    show_condition = show_condition * custom_conds.project.is_lua
  end

  local snippet = s(
    { trig = filetype .. "-file", show_condition = show_condition },
    { i(1, "name"), t("." .. extension) },
    { callbacks = callbacks }
  )

  table.insert(snippets, snippet)
end

return snippets
