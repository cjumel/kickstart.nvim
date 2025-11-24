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
  }, {
    t("alias "),
    i(1),
    t("='"),
    i(2),
    t("'"),
  }),
}
