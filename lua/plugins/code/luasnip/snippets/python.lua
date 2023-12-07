local ls = require("luasnip")

local c = ls.choice_node
local i = ls.insert_node
local s = ls.snippet

local fmt = require("luasnip.extras.fmt").fmt

local expand_conds = require("luasnip.extras.conditions.expand")
local custom_conds = require("plugins.code.luasnip.utils.conds")

return {
  s(
    "import",
    c(1, {
      fmt(
        [[
          import {}
        ]],
        {
          i(1, "module"),
        }
      ),
      fmt(
        [[
          import {} as {}
        ]],
        {
          i(1, "module"),
          i(2, "name"),
        }
      ),
    })
  ),
  s(
    "from",
    c(1, {
      fmt(
        [[
          from {} import {}
        ]],
        {
          i(1, "module"),
          i(2, "var"),
        }
      ),
      fmt(
        [[
          from {} import {} as {}
        ]],
        {
          i(1, "module"),
          i(2, "var"),
          i(3, "name"),
        }
      ),
    })
  ),
  s(
    {
      trig = "for ", -- new line version
      snippetType = "autosnippet",
      condition = custom_conds.is_in_code * expand_conds.line_begin,
    },
    c(1, {
      fmt(
        [[
          for {} in {}:
              {}
        ]],
        {
          i(1, "var"),
          i(2, "iterable"),
          i(3, "pass"),
        }
      ),
    })
  ),
  s(
    {
      trig = "for ", -- inline version
      snippetType = "autosnippet",
      condition = custom_conds.is_in_code * -expand_conds.line_begin,
    },
    c(1, {
      fmt(
        [[
          for {} in {}
        ]],
        {
          i(1, "var"),
          i(2, "iterable"),
        }
      ),
    })
  ),
  s(
    {
      trig = "def ",
      snippetType = "autosnippet",
      condition = custom_conds.is_in_code * expand_conds.line_begin,
    },
    c(1, {
      fmt(
        [[
          def {}({}) -> {}:
              {}
        ]],
        {
          i(1, "function"),
          i(2),
          i(3, "None"),
          i(4, "pass"),
        }
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
        {
          i(1, "function"),
          i(2),
          i(3, "None"),
          i(4),
          i(5),
          i(6),
          i(7, "pass"),
        }
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
      {
        i(1, "pass"),
      }
    )
  ),
}
