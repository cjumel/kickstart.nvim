local conds = require("config.snippets.conditions")
local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node

return {
  s({
    trig = "wip",
    show_condition = conds.line_begin,
    desc = [[Work In Progress commit, disable any CI.]],
  }, {
    t("🚧 WIP [skip ci]"),
  }),
}
