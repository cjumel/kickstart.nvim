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
    "local",
    c(1, {
      fmt("local {} = {}", { i(1, "var"), i(2, "value") }),
      fmt(
        [[
          local function {}({})
            {}
          end
        ]],
        { i(1, "name"), i(2), i(3) }
      ),
    })
  ),
  s("require", fmt([[require("{}")]], { i(1, "module") })),
  s(
    "function",
    fmt(
      [[
        function({})
          {}
        end
      ]],
      { i(1), i(2) }
    )
  ),
  s(
    {
      trig = "if ",
      snippetType = "autosnippet",
      condition = custom_conds.is_in_code * expand_conds.line_begin,
    },
    fmt(
      [[
        if {} then
          {}
        end
      ]],
      { i(1, "cond"), i(2) }
    )
  ),
  s(
    "elseif",
    fmt(
      [[
        elseif {} then
          {}
      ]],
      { i(1, "cond"), i(2) }
    )
  ),
  s(
    "else",
    fmt(
      [[
        else
          {}
      ]],
      { i(1) }
    )
  ),
  s(
    {
      trig = "for ",
      snippetType = "autosnippet",
      condition = custom_conds.is_in_code * expand_conds.line_begin,
    },
    fmt(
      [[
        for {} do
          {}
        end
      ]],
      {
        c(1, {
          i(1, "loop"),
          sn(nil, { i(1, "_"), t(", "), i(2, "var"), t(" in ipairs("), i(3, "table"), t(")") }),
        }),
        i(2),
      }
    )
  ),
}
