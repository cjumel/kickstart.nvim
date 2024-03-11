local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node

local custom_show_conds = require("plugins.core.luasnip.show_conds")
local show_conds = require("luasnip.extras.conditions.show")

return {
  s({
    trig = "init.lua",
    show_condition = custom_show_conds.line_begin * show_conds.line_end,
  }, { t("init.lua") }),
  s({
    trig = "scratch.lua",
    show_condition = custom_show_conds.line_begin * show_conds.line_end,
  }, { t("scratch.lua") }),
}
