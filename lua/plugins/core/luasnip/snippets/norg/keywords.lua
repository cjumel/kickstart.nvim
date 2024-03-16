local ls = require("luasnip")

local custom_conds = require("plugins.core.luasnip.conditions")

local c = ls.choice_node
local i = ls.insert_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

return {
  s({ trig = "todo-item", show_condition = custom_conds.ts.line_begin }, {
    c(1, {
      sn(nil, { t("- ( ) "), i(1) }),
      sn(nil, { t("-- ( ) "), i(1) }),
      sn(nil, { t("--- ( ) "), i(1) }),
    }),
  }),
}
