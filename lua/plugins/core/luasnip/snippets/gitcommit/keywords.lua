local conds = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node

return {
  s({ trig = "wip", show_condition = conds.line_begin }, { t("🚧 WIP [skip ci]") }),
}
