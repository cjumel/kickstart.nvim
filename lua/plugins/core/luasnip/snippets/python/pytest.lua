local custom_conditions = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")
local ls_conditions = require("luasnip.extras.conditions")
local ls_conditions_show = require("luasnip.extras.conditions.show")

local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

local function pytest_is_executable(_) return vim.fn.executable("pytest") == 1 end
local pytest_is_executable_condition = ls_conditions.make_condition(pytest_is_executable)

return {
  -- Let's only implement an "in-code" version (no "in-comment" one), as the latter cannot be as much controlled and
  -- will be available in any comment & at any place inside the comment
  s({
    trig = "ignore-pytest-cov",
    show_condition = pytest_is_executable_condition
      * custom_conditions.is_in_code
      * -custom_conditions.line_begin
      * ls_conditions_show.line_end,
  }, {
    t("# pragma: no cover"),
    i(1),
  }),
}
