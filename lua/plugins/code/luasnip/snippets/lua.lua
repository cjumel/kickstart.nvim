local ls = require("luasnip")

local c = ls.choice_node
local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

local fmt = require("luasnip.extras.fmt").fmt

return {
  s("local", fmt("local {i1} = {i2}", { i1 = i(1, "name"), i2 = i(2, [["var"]]) })),
  s("require", fmt([[require("{i1}")]], { i1 = i(1, "module") })),
  s(
    "function",
    fmt(
      [[
      function {i1}({i2})
        {i3}
      end
      ]],
      { i1 = i(1), i2 = i(2), i3 = i(3, "-- code") }
    )
  ),
  s(
    "todo-comment",
    fmt(
      "-- {c1}: {i2}",
      { c1 = c(1, { t("TODO"), t("NOTE"), t("BUG"), t("FIXME"), t("ISSUE") }), i2 = i(2, "text") }
    )
  ),
}
