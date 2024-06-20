local custom_conditions = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")
local ls_show_conditions = require("luasnip.extras.conditions.show")

local c = ls.choice_node
local i = ls.insert_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

return {
  s({ trig = "ruff-ignore", show_condition = custom_conditions.is_in_code * ls_show_conditions.line_end }, {
    c(1, {
      sn(nil, { t("# noqa: "), i(1) }),
      sn(nil, { t("# noqa"), i(1) }),
    }),
  }),
  s({ trig = "ruff-ignore", show_condition = custom_conditions.is_in_comment * ls_show_conditions.line_end }, {
    c(1, {
      sn(nil, { t("noqa: "), i(1) }),
      sn(nil, { t("noqa"), i(1) }),
    }),
  }),
}
