local ls = require("luasnip")

local c = ls.choice_node
local i = ls.insert_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local fmt = require("luasnip.extras.fmt").fmt

local show_conds = require("luasnip.extras.conditions.show")
local custom_show_conds = require("plugins.code.luasnip.show_conds")

return {
  s(
    {
      trig = "local",
      show_condition = (
        custom_show_conds.is_in_code
        * custom_show_conds.line_begin
        * show_conds.line_end
      ),
    },
    fmt("local {} = {}", {
      i(1, "var"),
      c(2, {
        i(nil, "{}"),
        i(nil, "nil"),
      }),
    })
  ),
  s(
    {
      trig = "local-function",
      show_condition = (
        custom_show_conds.is_in_code
        * custom_show_conds.line_begin
        * show_conds.line_end
      ),
    },
    fmt(
      [[
        local function {}({})
          {}
        end
      ]],
      { i(1, "name"), i(2), i(3) }
    )
  ),
  s({
    trig = "require",
    show_condition = custom_show_conds.is_in_code,
  }, fmt([[require("{}")]], { i(1, "module") })),
  s(
    {
      trig = "function",
      show_condition = custom_show_conds.is_in_code,
    },
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
      trig = "if",
      show_condition = (
        custom_show_conds.is_in_code
        * custom_show_conds.line_begin
        * show_conds.line_end
      ),
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
    {
      trig = "elseif",
      show_condition = (
        custom_show_conds.is_in_code
        * custom_show_conds.line_begin
        * show_conds.line_end
      ),
    },
    fmt(
      [[
        elseif {} then
          {}
      ]],
      { i(1, "cond"), i(2) }
    )
  ),
  s(
    {
      trig = "else",
      show_condition = (
        custom_show_conds.is_in_code
        * custom_show_conds.line_begin
        * show_conds.line_end
      ),
    },
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
      trig = "for",
      show_condition = (
        custom_show_conds.is_in_code
        * custom_show_conds.line_begin
        * show_conds.line_end
      ),
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
          sn(nil, { i(1, "k"), t(", "), i(2, "v"), t(" in pairs("), i(3, "table"), t(")") }),
          sn(nil, { i(1, "_"), t(", "), i(2, "var"), t(" in ipairs("), i(3, "table"), t(")") }),
        }),
        i(2),
      }
    )
  ),
}
