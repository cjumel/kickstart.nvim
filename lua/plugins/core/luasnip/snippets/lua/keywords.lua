-- Snippets for Lua keywords involving multiple words (simple one-word keywords are already handled
-- by lua_ls)
-- Many snippets here are inspired by the keyword snippets of lua_ls

local ls = require("luasnip")

local custom_conds = require("plugins.core.luasnip.conditions")
local show_conds = require("luasnip.extras.conditions.show")

local fmt = require("luasnip.extras.fmt").fmt

local i = ls.insert_node
local s = ls.snippet

local is_in_code = custom_conds.ts.is_in_code
local is_in_code_empty_line = custom_conds.ts.is_in_code
  * custom_conds.ts.line_begin
  * show_conds.line_end

return {

  -- Local
  s(
    { trig = "local .. = ..", show_condition = is_in_code_empty_line },
    fmt("local {} = {}", { i(1), i(2) })
  ),

  -- Function
  s(
    { trig = "function ()", show_condition = is_in_code },
    fmt(
      [[
        function {}({})
          {}
        end
      ]],
      { i(1), i(2), i(3) }
    )
  ),

  -- Conditions
  s(
    { trig = "if .. then", show_condition = is_in_code_empty_line },
    fmt(
      [[
        if {} then
          {}
        end
      ]],
      { i(1), i(2) }
    )
  ),
  s(
    { trig = "elsif .. then", show_condition = is_in_code_empty_line },
    fmt(
      [[
        elseif {} then
          {}
      ]],
      { i(1), i(2) }
    )
  ),
  s(
    { trig = "else", show_condition = is_in_code_empty_line },
    fmt(
      [[
        else
          {}
      ]],
      { i(1) }
    )
  ),

  -- For
  s(
    { trig = "for .. do", show_condition = is_in_code_empty_line },
    fmt(
      [[
        for {} do
          {}
        end
      ]],
      { i(1), i(2) }
    )
  ),
  s(
    { trig = "for .. pairs .. do", show_condition = is_in_code_empty_line },
    fmt(
      [[
        for {}, {} in pairs({}) do
          {}
        end
      ]],
      { i(1, "key"), i(2, "val"), i(3, "table"), i(4) }
    )
  ),
  s(
    { trig = "for .. ipairs .. do", show_condition = is_in_code_empty_line },
    fmt(
      [[
          for {}, {} in ipairs({}) do
            {}
          end
        ]],
      { i(1, "idx"), i(2, "val"), i(3, "table"), i(4) }
    )
  ),

  -- While
  s(
    { trig = "while .. do", show_condition = is_in_code_empty_line },
    fmt(
      [[
          while {} do
            {}
          end
        ]],
      { i(1), i(2) }
    )
  ),
}
