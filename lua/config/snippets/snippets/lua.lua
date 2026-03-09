local ls = require("luasnip")
local snippet_conds = require("config.snippets.conditions")

local c = ls.choice_node
local i = ls.insert_node
local r = ls.restore_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

return {
  s({ trig = "else", show_condition = snippet_conds.empty_line * snippet_conds.code }, { t("else "), i(1) }),

  s(
    { trig = "elseif", show_condition = snippet_conds.empty_line * snippet_conds.code },
    { t("elseif "), i(1), t({ " then", "\t" }), i(2) }
  ),

  s({ trig = "for", show_condition = snippet_conds.empty_line * snippet_conds.code }, {
    c(1, {
      sn(nil, { t("for "), i(1), t(" in "), i(2), t({ " do", "\t" }), r(3, "content", i(nil)), t({ "", "end" }) }),
      sn(nil, { t("for "), i(1), t({ " do", "\t" }), r(2, "content"), t({ "", "end" }) }),
    }),
  }),

  s({ trig = "function", show_condition = snippet_conds.code }, {
    c(1, {
      sn(nil, {
        t("function "),
        r(1, "name", i(nil)),
        t("("),
        r(2, "args", i(nil)),
        t({ ")", "\t" }),
        r(3, "content", i(nil)),
        t({ "", "end" }),
      }),
      sn(nil, {
        t("function "),
        r(1, "name"),
        t("("),
        r(2, "args"),
        t(") "),
        r(3, "content"),
        t(" end"),
      }),
    }),
  }),

  s(
    { trig = "if", show_condition = snippet_conds.empty_line * snippet_conds.code },
    { t("if "), i(1), t({ " then", "\t" }), i(2), t({ "", "end" }) }
  ),

  s({ trig = "local", show_condition = snippet_conds.empty_line * snippet_conds.code }, {
    c(1, {
      sn(nil, { t("local "), r(1, "name", i(nil)), t(" = "), i(2) }),
      sn(nil, { t("local "), r(1, "name") }),
    }),
  }),
  s({ trig = "local function", show_condition = snippet_conds.empty_line * snippet_conds.code }, {
    c(1, {
      sn(nil, {
        t("local function "),
        r(1, "name", i(nil)),
        t("("),
        r(2, "args", i(nil)),
        t({ ")", "\t" }),
        r(3, "content", i(nil)),
        t({ "", "end" }),
      }),
      sn(nil, {
        t("local function "),
        r(1, "name"),
        t("("),
        r(2, "args"),
        t(") "),
        r(3, "content"),
        t(" end"),
      }),
    }),
  }),
  s(
    { trig = "local … require", show_condition = snippet_conds.empty_line * snippet_conds.code },
    { t("local "), i(1), t(' = require("'), i(2), t('")') }
  ),

  s(
    { trig = "while", show_condition = snippet_conds.empty_line * snippet_conds.code },
    { t("while "), i(1), t({ " do", "\t" }), i(2), t({ "", "end" }) }
  ),
}
