local ls = require("luasnip")
local snippet_conds = require("config.snippets.conditions")

local c = ls.choice_node
local i = ls.insert_node
local r = ls.restore_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

return {
  s({ trig = "alias", show_condition = snippet_conds.empty_line }, { t("alias "), i(1), t("='"), i(2), t("'") }),

  s({ trig = "elif", show_condition = snippet_conds.empty_line }, {
    c(1, {
      sn(nil, { t("elif [ "), r(1, "cond", i(nil)), t(" ]; then"), t({ "", "\t" }), r(2, "content", i(nil, "pass")) }),
      sn(nil, { t("elif [ ! "), r(1, "cond"), t(" ]; then"), t({ "", "\t" }), r(2, "content") }),
    }),
  }),

  s({ trig = "else", show_condition = snippet_conds.empty_line }, { t({ "else", "\t" }), i(1) }),

  s({ trig = "export", show_condition = snippet_conds.empty_line }, { t("export "), i(1), t("="), i(2) }),

  s(
    { trig = "function", show_condition = snippet_conds.empty_line },
    { t("function "), i(1), t("("), i(2), t({ ") { ", "\t" }), i(3), t({ "", "}" }) }
  ),

  s(
    { trig = "if", show_condition = snippet_conds.empty_line },
    c(1, {
      sn(nil, {
        t("if [ "),
        r(1, "cond", i(nil)),
        t(" ]; then"),
        t({ "", "\t" }),
        r(2, "content", i(nil, "pass")),
        t({ "", "fi" }),
      }),
      sn(nil, { t("if [ ! "), r(1, "cond"), t(" ]; then"), t({ "", "\t" }), r(2, "content"), t({ "", "fi" }) }),
    })
  ),

  s({ trig = "local", show_condition = snippet_conds.empty_line }, {
    c(1, {
      sn(nil, { t("local "), r(1, "name", i(nil)), t("="), i(2) }),
      sn(nil, { t("local "), r(1, "name") }),
    }),
  }),
}
