local ls = require("luasnip")

local i = ls.insert_node
local s = ls.snippet

local fmt = require("luasnip.extras.fmt").fmt

return {
  s("local", fmt("local {i1} = {i2}", { i1 = i(1, "name"), i2 = i(2, [["value"]]) })),
  s("require", fmt([[require("{i1}")]], { i1 = i(1, "module") })),
  s(
    "function",
    fmt(
      [[
      function {i1}({i2})
        {i3}
      end
      ]],
      { i1 = i(1), i2 = i(2), i3 = i(3) }
    )
  ),
}
