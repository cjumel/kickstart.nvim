local ls = require("luasnip")

local custom_conditions = require("plugins.core.luasnip.conditions")

local i = ls.insert_node
local c = ls.choice_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local keywords = {
  "build",
  "chore",
  "ci",
  "docs",
  "feat",
  "fix",
  "perf",
  "refactor",
  "revert",
  "style",
  "test",
}

local function make_snippet(keyword)
  return s({ trig = keyword, show_condition = custom_conditions.line_begin }, {
    c(1, {
      sn(nil, { t(keyword .. ": "), i(1) }),
      sn(nil, { t(keyword .. "("), i(1), t("): ") }), -- With scope
      sn(nil, { t(keyword .. "("), i(1), t(")!: ") }), -- With scope & breaking change
      sn(nil, { t(keyword .. "!: "), i(1) }), -- With breaking change
    }),
  })
end

local snippets = {}
for _, keyword in ipairs(keywords) do
  table.insert(snippets, make_snippet(keyword))
end

return snippets
