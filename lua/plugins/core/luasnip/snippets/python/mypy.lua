local custom_conditions = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")
local ls_show_conditions = require("luasnip.extras.conditions.show")

local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

local ls_conditions = require("luasnip.extras.conditions")

local function mypy_is_executable(_) return vim.fn.executable("mypy") == 1 end
local mypy_is_executable_condition = ls_conditions.make_condition(mypy_is_executable)

return {
  s({
    trig = "mypy-ignore",
    show_condition = custom_conditions.is_in_code * ls_show_conditions.line_end * mypy_is_executable_condition,
  }, {
    t("# type: ignore"),
    i(1),
  }),
  s({
    trig = "mypy-ignore",
    show_condition = custom_conditions.is_in_comment * ls_show_conditions.line_end * mypy_is_executable_condition,
  }, {
    t("type: ignore"),
    i(1),
  }),
}
