local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node

local custom_show_conds = require("plugins.core.luasnip.show_conds")
local show_conds = require("luasnip.extras.conditions.show")

return {
  s({
    trig = "__init__.py",
    show_condition = custom_show_conds.line_begin * show_conds.line_end,
  }, { t("__init__.py") }),
  s({
    trig = "scratch.py",
    show_condition = custom_show_conds.line_begin * show_conds.line_end,
  }, { t("scratch.py") }),
}
