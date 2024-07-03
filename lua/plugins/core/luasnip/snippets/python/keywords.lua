local custom_conditions = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")
local ls_extras = require("luasnip.extras")

local c = ls.choice_node
local d = ls.dynamic_node
local i = ls.insert_node
local rep = ls_extras.rep
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local function is_function_in_class()
  local node = vim.treesitter.get_node()

  if node == nil then
    return false
  elseif node:type() == "class_definition" then
    return true
  elseif node:parent() ~= nil and node:parent():type() == "class_definition" then
    return true
  else
    return false
  end
end

local def_dymamic_name = function(_)
  if is_function_in_class() then
    return sn(nil, { c(1, { i(1, "function"), t("__init__"), t("__call__") }) })
  else
    return sn(nil, { c(1, { i(1, "function"), t("main") }) })
  end
end

local def_dynamic_args = function(_)
  if is_function_in_class() then
    return sn(nil, { c(1, { sn(nil, { t("self"), i(1) }), sn(nil, { t("cls"), i(1) }), sn(nil, { i(1) }) }) })
  else
    return sn(nil, { i(1) })
  end
end

return {

  -- [[ Imports ]]
  s({ trig = "import ..", show_condition = custom_conditions.is_in_code_empty_line }, {
    t("import "),
    i(1),
  }),
  s({ trig = "import .. as ..", show_condition = custom_conditions.is_in_code_empty_line }, {
    t("import "),
    i(1),
    t(" as "),
    i(2),
  }),
  s({ trig = "from .. import ..", show_condition = custom_conditions.is_in_code_empty_line }, {
    t("from "),
    i(1),
    t(" import "),
    i(2),
  }),
  s({ trig = "from .. import .. as ..", show_condition = custom_conditions.is_in_code_empty_line }, {
    t("from "),
    i(1),
    t(" import "),
    i(2),
    t(" as "),
    i(3),
  }),

  -- [[ Conditions ]]
  -- Block version
  s({ trig = "if ..", show_condition = custom_conditions.is_in_code_empty_line }, {
    t("if "),
    c(1, { i(1), sn(nil, { t("not "), i(1) }) }),
    t({ ":", "\t" }),
    c(2, { i(1), sn(nil, { t("pass"), i(1) }) }),
  }),
  s({ trig = "elif ..", show_condition = custom_conditions.is_in_code_empty_line }, {
    t("elif "),
    c(1, { i(1), sn(nil, { t("not "), i(1) }) }),
    t({ ":", "\t" }),
    c(2, { i(1), sn(nil, { t("pass"), i(1) }) }),
  }),
  s({ trig = "else ..", show_condition = custom_conditions.is_in_code_empty_line }, {
    t({ "else:", "\t" }),
    c(1, { i(1), sn(nil, { t("pass"), i(1) }) }),
  }),
  s({ trig = 'if .. "__main__"', show_condition = custom_conditions.is_in_code_empty_line }, {
    t({ 'if __name__ == "__main__":', "\t" }),
    c(1, {
      i(1),
      sn(nil, { t("pass"), i(1) }),
    }),
  }),
  s({ trig = "if .. None .. raise ..", show_condition = custom_conditions.is_in_code_empty_line }, {
    c(1, {
      sn(nil, {
        t("if "),
        i(1),
        t({ " is None:", "\t" }),
        t([[raise ValueError("Expected ']]),
        rep(1),
        t([[' to be not None")]]),
      }),
      sn(nil, {
        t("if "),
        i(1),
        t({ " is not None:", "\t" }),
        t([[raise ValueError("Expected ']]),
        rep(1),
        t([[' to be None")]]),
      }),
    }),
  }),
  s({ trig = "if not isinstance .. raise ..", show_condition = custom_conditions.is_in_code_empty_line }, {
    c(1, {
      sn(nil, {
        t("if not isinstance("),
        i(1),
        t(", "),
        i(2), -- support union & or tuple for multiple types
        t({ "):", "\t" }),
        t([[raise TypeError(f"Expected ']]),
        rep(1),
        t([[' to be of type ']]),
        rep(2),
        t([[' but got '{type(]]),
        rep(1),
        t([[)}'")]]),
      }),
      sn(nil, {
        t("if isinstance("),
        i(1),
        t(", "),
        i(2), -- support union & or tuple for multiple types
        t({ "):", "\t" }),
        t([[raise TypeError(f"Expected ']]),
        rep(1),
        t([[' not to be of type ']]),
        rep(2),
        t([['")]]),
      }),
    }),
  }),
  -- Inline version
  s({ trig = "if .. else ..", show_condition = custom_conditions.is_in_code_inline }, {
    t("if "),
    i(1),
    t(" else "),
    c(2, { i(1), t("None") }),
  }),

  -- [[ Loops ]]
  -- Block version
  s({ trig = "for .. in ..", show_condition = custom_conditions.is_in_code_empty_line }, {
    t("for "),
    i(1),
    t(" in "),
    i(2),
    t({ ":", "\t" }),
    c(3, { i(1), sn(nil, { t("pass"), i(1) }) }),
  }),
  s({ trig = "for .. enumerate ..", show_condition = custom_conditions.is_in_code_empty_line }, {
    t("for "),
    i(1, "i"),
    t(", "),
    i(2, "x"),
    t(" in enumerate("),
    i(3),
    t({ "):", "\t" }),
    c(4, { i(1), sn(nil, { t("pass"), i(1) }) }),
  }),
  s({ trig = "for .. range ..", show_condition = custom_conditions.is_in_code_empty_line }, {
    t("for "),
    i(1, "i"),
    t(" in range("),
    i(2),
    t({ "):", "\t" }),
    c(3, { i(1), sn(nil, { t("pass"), i(1) }) }),
  }),
  s({ trig = "for .. zip ..", show_condition = custom_conditions.is_in_code_empty_line }, {
    t("for "),
    i(1, "x"),
    t(", "),
    i(2, "y"),
    t(" in zip("),
    i(3),
    t({ "):", "\t" }),
    c(4, { i(1), sn(nil, { t("pass"), i(1) }) }),
  }),
  s({ trig = "async for .. in ..", show_condition = custom_conditions.is_in_code_empty_line }, {
    t("async for "),
    i(1),
    t(" in "),
    i(2),
    t({ ":", "\t" }),
    c(3, { i(1), sn(nil, { t("pass"), i(1) }) }),
  }),
  -- Inline version
  s({ trig = "for .. in ..", show_condition = custom_conditions.is_in_code_inline }, {
    t("for "),
    i(1),
    t(" in "),
    i(2),
  }),
  s({ trig = "for .. enumerate ..", show_condition = custom_conditions.is_in_code_inline }, {
    t("for "),
    i(1, "i"),
    t(", "),
    i(2, "x"),
    t(" in enumerate("),
    i(3),
    t(")"),
  }),
  s({ trig = "for .. range ..", show_condition = custom_conditions.is_in_code_inline }, {
    t("for "),
    i(1, "i"),
    t(" in range("),
    i(2),
    t(")"),
  }),
  s({ trig = "for .. zip ..", show_condition = custom_conditions.is_in_code_inline }, {
    t("for "),
    i(1, "x"),
    t(", "),
    i(2, "y"),
    t(" in zip("),
    i(3),
    t(")"),
  }),

  -- [[ Errors handling ]]
  s({ trig = "try .. except", show_condition = custom_conditions.is_in_code_empty_line }, {
    t({ "try:", "\t" }),
    c(1, { i(1), sn(nil, { t("pass"), i(1) }) }),
    t({ "", "except " }),
    c(2, { i(1), sn(nil, { i(1), t(" as "), i(2) }) }),
    t({ ":", "\t" }),
    c(3, { i(1), sn(nil, { t("pass"), i(1) }) }),
  }),
  s({ trig = "try .. finally", show_condition = custom_conditions.is_in_code_empty_line }, {
    t({ "try:", "\t" }),
    c(1, { i(1), sn(nil, { t("pass"), i(1) }) }),
    t({ "", "finally:", "\t" }),
    c(2, { i(1), sn(nil, { t("pass"), i(1) }) }),
  }),

  -- [[ Functions ]]
  s({ trig = "def ..", show_condition = custom_conditions.is_in_code_empty_line }, {
    t("def "),
    d(1, def_dymamic_name),
    t("("),
    d(2, def_dynamic_args),
    t(")"),
    c(3, { sn(nil, { t(" -> "), i(1) }), sn(nil, { t(" -> "), i(1, "None") }), sn(nil, { i(1) }) }),
    t({ ":", "\t" }),
    c(4, { i(1), sn(nil, { t("pass"), i(1) }) }),
  }),
  s({ trig = "async def ..", show_condition = custom_conditions.is_in_code_empty_line }, {
    t("async def "),
    d(1, def_dymamic_name),
    t("("),
    d(2, def_dynamic_args),
    t(")"),
    c(3, { sn(nil, { t(" -> "), i(1) }), sn(nil, { t(" -> "), i(1, "None") }), sn(nil, { i(1) }) }),
    t({ ":", "\t" }),
    c(4, { i(1), sn(nil, { t("pass"), i(1) }) }),
  }),

  -- [[ Classes ]]
  s({ trig = "class ..", show_condition = custom_conditions.is_in_code_empty_line }, {
    t("class "),
    c(1, { i(1, "Name"), sn(nil, { i(1, "Name"), t("("), i(2, "Parent"), t(")") }) }),
    t({ ":", "\t" }),
    c(2, { i(1), sn(nil, { t("pass"), i(1) }) }),
  }),
}
