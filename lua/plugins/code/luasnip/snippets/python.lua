local ls = require("luasnip")

local i = ls.insert_node
local s = ls.snippet

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
    "for",
    fmt(
      [[
      for {i1} in {i2}:
          {i3}
      ]],
      { i1 = i(1, "var"), i2 = i(2, "iterable"), i3 = i(3, "pass") }
    )
  ),
  s(
    "for-enumerate",
    fmt(
      [[
      for {i1}, {i2} in enumerate({i3}):
          {i4}
      ]],
      { i1 = i(1, "i"), i2 = i(2, "var"), i3 = i(3, "iterable"), i4 = i(4, "pass") }
    )
  ),
  s(
    "def",
    fmt(
      [[
      def {i1}({i2}) -> {i3}:
          {i4}
      ]],
      { i1 = i(1, "name"), i2 = i(2), i3 = i(3, "None"), i4 = i(4, "pass") }
    )
  ),
  s(
    "main",
    fmt(
      [[
      if __name__ == "__main__":
          {i1}
      ]],
      { i1 = i(1, "pass") }
    )
  ),
}
