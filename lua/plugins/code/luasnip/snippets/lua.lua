local ls = require("luasnip")

local c = ls.choice_node
local i = ls.insert_node
local s = ls.snippet

local fmt = require("luasnip.extras.fmt").fmt

local expand_conds = require("luasnip.extras.conditions.expand")
local custom_conds = require("plugins.code.luasnip.custom.conds")

return {
  s(
    {
      trig = "loc ",
      snippetType = "autosnippet",
      condition = custom_conds.is_in_code * expand_conds.line_begin,
    },
    fmt(
      [[
        local {} = {}
      ]],
      {
        i(1, "var"),
        i(2, [["value"]]),
      }
    )
  ),
  s(
    {
      trig = "req ",
      snippetType = "autosnippet",
      condition = custom_conds.is_in_code,
    },
    fmt(
      [[
        require("{}")
      ]],
      {
        i(1, "module"),
      }
    )
  ),
  s(
    {
      trig = "fun ",
      snippetType = "autosnippet",
      condition = custom_conds.is_in_code,
    },
    fmt(
      [[
        function {}({})
          {}
        end
      ]],
      {
        i(1),
        i(2),
        i(3),
      }
    )
  ),
  s(
    {
      trig = "ret ",
      snippetType = "autosnippet",
      condition = custom_conds.is_in_code * expand_conds.line_begin,
    },
    fmt(
      [[
        return {}
      ]],
      {
        i(1, "nil"),
      }
    )
  ),
  s(
    {
      trig = "if ",
      snippetType = "autosnippet",
      condition = custom_conds.is_in_code * expand_conds.line_begin,
    },
    c(1, {
      fmt(
        [[
          if {} then
            {}
          end
        ]],
        {
          i(1, "cond"),
          i(2),
        }
      ),
      fmt(
        [[
          if {} then
            {}
          else
            {}
          end
        ]],
        {
          i(1, "cond"),
          i(2),
          i(3),
        }
      ),
    })
  ),
  s(
    {
      trig = "for ",
      snippetType = "autosnippet",
      condition = custom_conds.is_in_code * expand_conds.line_begin,
    },
    c(1, {
      fmt(
        [[
          for {} do
            {}
          end
        ]],
        {
          i(1, "loop"),
          i(2),
        }
      ),
      fmt(
        [[
          for {}, {} in ipairs({}) do
            {}
          end
        ]],
        {
          i(1, "idx"),
          i(2, "var"),
          i(3, "iterable"),
          i(4),
        }
      ),
    })
  ),
}
