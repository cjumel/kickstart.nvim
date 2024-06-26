local custom_conditions = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")
local ls_conditions = require("luasnip.extras.conditions")
local ls_conditions_show = require("luasnip.extras.conditions.show")

local c = ls.choice_node
local i = ls.insert_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local function mypy_is_executable(_) return vim.fn.executable("mypy") == 1 end
local mypy_is_executable_condition = ls_conditions.make_condition(mypy_is_executable)

return {
  -- Let's only implement an "in-code" version (no "in-comment" one), as the latter cannot be as much controlled and
  -- will be available in any comment & at any place inside the comment
  s({
    trig = "ignore-mypy",
    show_condition = mypy_is_executable_condition
      * custom_conditions.is_in_code
      * -custom_conditions.line_begin
      * ls_conditions_show.line_end,
  }, {
    c(1, {
      sn(nil, { t("# type: ignore"), i(1) }),
      sn(nil, { t("# type: ignore["), i(1), t("]") }),
    }),
  }),
}
