-- TODO: show_condition calls have been commented out since they don't work well currently with blink.cmp

local ls = require("luasnip")

local conds = require("config.snippets.conditions")

local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

return {
  s({
    trig = "alias",
    -- show_condition = conds.line_begin * conds.line_end,
    desc = [[`alias …='…'`]],
  }, {
    t("alias "),
    i(1),
    t("='"),
    i(2),
    t("'"),
  }),
}
