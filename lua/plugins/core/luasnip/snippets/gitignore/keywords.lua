local custom_conditions = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node

return {
  s({ trig = ".DS_Store", show_condition = custom_conditions.empty_line }, { t(".DS_Store") }),
}
