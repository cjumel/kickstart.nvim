local ls = require("luasnip")

local c = ls.choice_node
local i = ls.insert_node
local s = ls.snippet

local fmt = require("luasnip.extras.fmt").fmt

local expand_conds = require("luasnip.extras.conditions.expand")
local custom_conds = require("plugins.code.luasnip.utils.conds")

return {
  s(
    "local",
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
    "require",
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
    "function",
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
