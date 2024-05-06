local ls = require("luasnip")

local custom_conditions = require("plugins.core.luasnip.conditions")

local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

return {
  s(
    { trig = "alias", show_condition = custom_conditions.line_begin },
    { t("alias "), i(1, "name"), t("='"), i(2), t("'") }
  ),
  s(
    { trig = "export", show_condition = custom_conditions.line_begin },
    { t("export "), i(1, "name"), t("='"), i(2), t("'") }
  ),
  s(
    { trig = "function", show_condition = custom_conditions.line_begin },
    { t("function "), i(1, "name"), t("("), i(2), t({ ") { ", "\t" }), i(3), t({ "", "}" }) }
  ),
  s({ trig = "local", show_condition = custom_conditions.line_begin }, { t("local "), i(1, "name"), t("="), i(2) }),
}
