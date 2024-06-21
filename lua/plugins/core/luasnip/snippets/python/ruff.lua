local custom_conditions = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")
local ls_conditions_show = require("luasnip.extras.conditions.show")

local c = ls.choice_node
local i = ls.insert_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

return {
  -- Let's only implement "in-code" versions (no "in-comment" ones), as the latter cannot be as much controlled and
  -- will be available in any comment & at any place inside the comment
  s({
    trig = "ruff-ignore",
    show_condition = custom_conditions.is_in_code * -custom_conditions.line_begin * ls_conditions_show.line_end,
  }, {
    c(1, {
      sn(nil, { t("# noqa"), i(1) }),
      sn(nil, { t("# noqa: "), i(1) }),
    }),
  }),
  s({
    trig = "ruff-ignore",
    show_condition = custom_conditions.first_line
      * custom_conditions.is_in_code
      * custom_conditions.line_begin
      * ls_conditions_show.line_end,
  }, {
    c(1, {
      sn(nil, { t("# ruff: noqa"), i(1) }),
      sn(nil, { t("# ruff: noqa: "), i(1) }),
    }),
  }),
}
