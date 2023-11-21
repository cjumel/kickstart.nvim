local ls = require("luasnip")

local c = ls.choice_node
local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

local fmt = require("luasnip.extras.fmt").fmt

return {
  s("import", fmt("import {i1}", { i1 = i(1, "module") })),
  s("import-as", fmt("import {i1} as {i2}", { i1 = i(1, "module"), i2 = i(2, "name") })),
  s("from-import", fmt("from {i1} import {i2}", { i1 = i(1, "module"), i2 = i(2, "var") })),
  s(
    "from-import-as",
    fmt(
      "from {i1} import {i2} as {i3}",
      { i1 = i(1, "module"), i2 = i(2, "var"), i3 = i(3, "name") }
    )
  ),
  s(
    "def",
    fmt(
      [[
      def {i1}() -> {i2}:
          {i3}
      ]],
      { i1 = i(1, "name"), i2 = i(2, "type"), i3 = i(3, "# code") }
    )
  ),
  s(
    "todo-comment",
    fmt(
      "# {c1}: {i2}",
      { c1 = c(1, { t("TODO"), t("NOTE"), t("BUG"), t("FIXME"), t("ISSUE") }), i2 = i(2, "text") }
    )
  ),
}
