local custom_conditions = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")

local c = ls.choice_node
local i = ls.insert_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

return {
  s({ trig = "local .. = ..", show_condition = custom_conditions.is_in_code_empty_line }, {
    t("local "),
    i(1),
    c(2, {
      i(1),
      sn(nil, { t(" = "), i(1) }),
      sn(nil, { t(" = "), t([[require("]]), i(1), t([[")]]) }),
    }),
  }),
  s({ trig = "function ()", show_condition = custom_conditions.is_in_code }, {
    c(1, {
      sn(nil, { t("function "), i(1), t("("), i(2), t({ ")", "\t" }), i(3), t({ "", "end" }) }),
      sn(nil, { t("function "), i(1), t("("), i(2), t(") "), i(3), t(" end") }),
    }),
  }),

  -- [[ Conditions ]]
  s(
    { trig = "if .. then", show_condition = custom_conditions.is_in_code_empty_line },
    { t("if "), c(1, { i(1), sn(nil, { t("not "), i(1) }) }), t({ " then", "\t" }), i(2), t({ "", "end" }) }
  ),
  s(
    { trig = "elsif .. then", show_condition = custom_conditions.is_in_code_empty_line },
    { t("elseif "), c(1, { i(1), sn(nil, { t("not "), i(1) }) }), t({ " then", "\t" }), i(2) }
  ),
  s({ trig = "else", show_condition = custom_conditions.is_in_code_empty_line }, { t({ "else", "\t" }), i(1) }),

  -- [[ Loops ]]
  s(
    { trig = "for .. do", show_condition = custom_conditions.is_in_code_empty_line },
    { t("for "), i(1), t({ " do", "\t" }), i(2), t({ "", "end" }) }
  ),
  s({ trig = "for .. pairs ..", show_condition = custom_conditions.is_in_code_empty_line }, {
    t("for "),
    i(1, "k"),
    t(", "),
    i(2, "v"),
    t(" in pairs("),
    i(3, "t"),
    t({ ") do", "\t" }),
    i(4),
    t({ "", "end" }),
  }),
  s({ trig = "for .. ipairs ..", show_condition = custom_conditions.is_in_code_empty_line }, {
    t("for "),
    c(1, { i(1, "i"), t("_") }), -- Typing "_" to replace "i" is broken for some reason
    t(", "),
    i(2, "x"),
    t(" in ipairs("),
    i(3, "t"),
    t({ ") do", "\t" }),
    i(4),
    t({ "", "end" }),
  }),
  s(
    { trig = "for .. range ..", show_condition = custom_conditions.is_in_code_empty_line },
    { t("for "), i(1, "i"), t(" = "), i(2, "start"), t(", "), i(3, "end_"), t({ " do", "\t" }), i(4), t({ "", "end" }) }
  ),
  s(
    { trig = "while .. do", show_condition = custom_conditions.is_in_code_empty_line },
    { t("while "), i(1), t({ " do", "\t" }), i(2), t({ "", "end" }) }
  ),
}
