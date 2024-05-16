local ls = require("luasnip")

local custom_conditions = require("plugins.core.luasnip.conditions")

local s = ls.snippet
local t = ls.text_node

return {
  s({ trig = "wip", show_condition = custom_conditions.line_begin }, { t("🚧 WIP [skip ci]") }),
}
