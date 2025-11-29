local ls = require("luasnip")
local snippet_conds = require("config.snippets.conditions")

local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

return {
  s({
    trig = "alias",
    show_condition = snippet_conds.line_begin * snippet_conds.line_end,
    desc = [[`alias …='…'`]],
  }, { t("alias "), i(1), t("='"), i(2), t("'") }),

  s({
    trig = "export",
    show_condition = snippet_conds.line_begin * snippet_conds.line_end,
    desc = [[`export …='…'`]],
  }, { t("export "), i(1), t("='"), i(2), t("'") }),

  s({
    trig = "function",
    show_condition = snippet_conds.line_begin * snippet_conds.line_end,
    desc = [[`function …(…) { … }`]],
  }, { t("function "), i(1), t("("), i(2), t({ ") { ", "\t" }), i(3), t({ "", "}" }) }),

  s({
    trig = "local",
    show_condition = snippet_conds.line_begin * snippet_conds.line_end,
    desc = [[`local …=…`]],
  }, { t("local "), i(1), t("="), i(2) }),
}
