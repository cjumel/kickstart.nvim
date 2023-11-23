local ls = require("luasnip")

local c = ls.choice_node
local i = ls.insert_node
local s = ls.snippet

local fmt = require("luasnip.extras.fmt").fmt

local custom_conds = require("plugins.code.luasnip.custom.conds")

return {
  s(
    { trig = "imp ", snippetType = "autosnippet", condition = custom_conds.is_in_code },
    c(1, {
      fmt("import {}", { i(1, "module") }),
      fmt("import {} as {}", { i(1, "module"), i(2, "name") }),
    })
  ),
  s(
    { trig = "from ", snippetType = "autosnippet", condition = custom_conds.is_in_code },
    c(1, {
      fmt("from {} import {}", { i(1, "module"), i(2, "var") }),
      fmt("from {} import {} as {}", { i(1, "module"), i(2, "var"), i(3, "name") }),
    })
  ),
  s(
    { trig = "for ", snippetType = "autosnippet", condition = custom_conds.is_in_code },
    c(1, {
      fmt("for {} in {}", { i(1, "var"), i(2, "iterable") }),
      fmt("for {}, {} in enumerate({})", { i(1, "idx"), i(2, "var"), i(3, "iterable") }),
      fmt("for {} in range({})", { i(1, "idx"), i(2, "integer") }),
      fmt("for {} in zip({})", { i(1, "vars"), i(2, "iterables") }),
    })
  ),
  s(
    { trig = "def ", snippetType = "autosnippet", condition = custom_conds.is_in_code },
    c(1, {
      fmt(
        [[
      def {}({}) -> {}:
          {}
      ]],
        { i(1, "function"), i(2), i(3, "None"), i(4, "pass") }
      ),
      fmt(
        [[
      def {}({}) -> {}:
          """{}

          Args:
              {}

          Returns:
              {}
          """
          {}
      ]],
        { i(1, "function"), i(2), i(3, "None"), i(4), i(5), i(6), i(7, "pass") }
      ),
    })
  ),
  s(
    { trig = "_main_", snippetType = "autosnippet", condition = custom_conds.is_in_code },
    fmt(
      [[
      if __name__ == "__main__":
          {i1}
      ]],
      { i1 = i(1, "pass") }
    )
  ),
}
