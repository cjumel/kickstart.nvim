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
    fmt(
      [[
        local {}
      ]],
      {
        c(1, {
          sn(nil, { i(1, "var"), t(" = "), i(2, [["value"]]) }),
          sn(nil, {
            t("function "),
            i(1, "name"),
            t("("),
            i(2),
            t({ ")", "  " }),
            i(3),
            t({ "", "end" }),
          }),
        }),
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
        function({})
          {}
        end
      ]],
      {
        i(1),
        i(2),
      }
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
        {}
      ]],
      {
        i(1, "cond"),
        i(2),
        c(3, {
          t("end"),
          sn(nil, {
            t({ "else", "  " }),
            i(1),
            t({ "", "end" }),
          }),
        }),
      }
    )
  ),
  s(
    "elseif",
    fmt(
      [[
        elseif {} then
          {}
      ]],
      {
        i(1, "cond"),
        i(2),
      }
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
          sn(nil, {
            i(1, "_"),
            t(", "),
            i(2, "var"),
            t(" in ipairs("),
            i(3, "table"),
            t(")"),
          }),
        }),
        i(2),
      }
    )
  ),
}
