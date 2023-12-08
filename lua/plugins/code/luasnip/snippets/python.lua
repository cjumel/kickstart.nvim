local ls = require("luasnip")

local c = ls.choice_node
local i = ls.insert_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local fmt = require("luasnip.extras.fmt").fmt

local expand_conds = require("luasnip.extras.conditions.expand")
local custom_conds = require("plugins.code.luasnip.utils.conds")

return {
  s(
    "import",
    c(1, {
      fmt("import {}", { i(1, "module") }),
      fmt("import {} as {}", { i(1, "module"), i(2, "name") }),
    })
  ),
  s(
    "from",
    c(1, {
      fmt("from {} import {}", { i(1, "module"), i(2, "var") }),
      fmt("from {} import {} as {}", { i(1, "module"), i(2, "var"), i(3, "name") }),
    })
  ),
  s(
    {
      trig = "if ", -- New line version
      snippetType = "autosnippet",
      condition = custom_conds.is_in_code * expand_conds.line_begin,
    },
    fmt(
      [[
        if {}:
            {}
      ]],
      { i(1, "cond"), i(2, "pass") }
    )
  ),
  s(
    "elif",
    fmt(
      [[
        elif {}:
            {}
      ]],
      { i(1, "cond"), i(2, "pass") }
    )
  ),
  s(
    "else",
    fmt(
      [[
        else:
            {}
      ]],
      { i(1, "pass") }
    )
  ),
  s(
    {
      trig = "for ", -- New line version
      snippetType = "autosnippet",
      condition = custom_conds.is_in_code * expand_conds.line_begin,
    },
    fmt(
      [[
        for {} in {}:
            {}
      ]],
      {
        i(1, "var"),
        c(2, {
          i(nil, "iterable"),
          sn(nil, { t("enumerate("), i(1, "iterable"), t(")") }),
          sn(nil, { t("range("), i(1, "integer"), t(")") }),
          sn(nil, { t("zip("), i(1, "iterables"), t(")") }),
        }),
        i(3, "pass"),
      }
    )
  ),
  s(
    "while",
    fmt(
      [[
        while {}:
            {}
      ]],
      { i(1, "cond"), i(2, "pass") }
    )
  ),
  s(
    {
      trig = "def ",
      snippetType = "autosnippet",
      condition = custom_conds.is_in_code * expand_conds.line_begin,
    },
    fmt(
      [[
        def {}({}) -> {}:
            {}
      ]],
      {
        i(1, "function"),
        c(2, {
          t(""),
          sn(nil, { t("self"), i(1) }),
          sn(nil, { t("cls"), i(1) }),
        }),
        i(3, "None"),
        i(4, "pass"),
      }
    )
  ),
  s(
    "lambda",
    fmt(
      [[
        lambda {}: {}
      ]],
      {
        i(1, "x"),
        i(2, "pass"),
      }
    )
  ),
  s(
    "class",
    c(1, {
      fmt(
        [[
          class {}:
              {}
        ]],
        { i(1, "Name"), i(2, "pass") }
      ),
      fmt(
        [[
          class {}({}):
              {}
        ]],
        { i(1, "Name"), i(2, "Parent"), i(3, "pass") }
      ),
    })
  ),
  s(
    {
      trig = [["""]], -- Remaining """ are inserted by nvim-autopairs
      snippetType = "autosnippet",
      condition = custom_conds.is_in_code * expand_conds.line_begin,
    },
    c(1, {
      fmt(
        [[
          """{}
        ]],
        { i(1) }
      ),
      fmt(
        [[
          """{}

          Args:
              {}

          Returns:
              {}

        ]],
        { i(1), i(2), i(3) }
      ),
      fmt(
        [[
          """{}

          Attributes:
              {}

        ]],
        { i(1), i(2) }
      ),
    })
  ),
  s(
    "__main__",
    fmt(
      [[
        if __name__ == "__main__":
            {}
      ]],
      { i(1, "pass") }
    )
  ),
}
