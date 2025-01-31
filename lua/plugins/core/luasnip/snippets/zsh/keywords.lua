local ls = require("luasnip")

local conds = require("plugins.core.luasnip.conditions")
local ls_show_conds = require("luasnip.extras.conditions.show")

local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

return {
  s(
    { trig = "alias", show_condition = conds.line_begin * ls_show_conds.line_end },
    { t("alias "), i(1, "name"), t("='"), i(2), t("'") }
  ),
  s(
    { trig = "export", show_condition = conds.line_begin * ls_show_conds.line_end },
    { t("export "), i(1, "name"), t("='"), i(2), t("'") }
  ),
  s(
    { trig = "function", show_condition = conds.line_begin * ls_show_conds.line_end },
    { t("function "), i(1, "name"), t("("), i(2), t({ ") { ", "\t" }), i(3), t({ "", "}" }) }
  ),
  s(
    { trig = "local", show_condition = conds.line_begin * ls_show_conds.line_end },
    { t("local "), i(1, "name"), t("="), i(2) }
  ),
}
