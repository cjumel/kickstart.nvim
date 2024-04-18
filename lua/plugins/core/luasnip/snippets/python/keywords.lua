-- Snippets for Python keywords involving multiple words (simple one-word keyword completion is
-- directly handled by the LSP)

local extras = require("luasnip.extras")
local ls = require("luasnip")
local show_conds = require("luasnip.extras.conditions.show")

local custom_conds = require("plugins.core.luasnip.conditions")

local c = ls.choice_node
local d = ls.dynamic_node
local i = ls.insert_node
local rep = extras.rep
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local is_in_code_empty_line = custom_conds.ts.is_in_code * custom_conds.line_begin * show_conds.line_end
local is_in_code_inline = custom_conds.ts.is_in_code * -custom_conds.line_begin

local todo = "raise NotImplementedError  # TO" .. "DO: implement" -- not recognized by todo-comments

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

local def_nynamic_args = function(_)
  if is_function_in_class() then
    return sn(nil, { c(1, { sn(nil, { t("self"), i(1) }), sn(nil, { t("cls"), i(1) }), sn(nil, { i(1) }) }) })
  else
    return sn(nil, { i(1) })
  end
end

return {

  -- [[ import ]]
  s({ trig = "import ..", show_condition = is_in_code_empty_line }, {
    t("import "),
    i(1),
  }),
  s({ trig = "import .. as ..", show_condition = is_in_code_empty_line }, {
    t("import "),
    i(1),
    t(" as "),
    i(2),
  }),
  s({ trig = "from .. import ..", show_condition = is_in_code_empty_line }, {
    t("from "),
    i(1),
    t(" import "),
    i(2),
  }),
  s({ trig = "from .. import .. as ..", show_condition = is_in_code_empty_line }, {
    t("from "),
    i(1),
    t(" import "),
    i(2),
    t(" as "),
    i(3),
  }),

  -- [[ if, else & elif ]]

  -- Block version
  s({ trig = "if ..", show_condition = is_in_code_empty_line }, {
    t("if "),
    i(1),
    t({ ":", "\t" }),
    c(2, { i(1), t(todo), t("pass") }),
  }),
  s({ trig = "elif ..", show_condition = is_in_code_empty_line }, {
    t("elif "),
    i(1),
    t({ ":", "\t" }),
    c(2, { i(1), t(todo), t("pass") }),
  }),
  s({ trig = "else ..", show_condition = is_in_code_empty_line }, {
    t("else:"),
    t("\t"),
    c(2, { i(1), t(todo), t("pass") }),
  }),

  -- Special cases in block version
  s({ trig = "if .. None .. raise ..", show_condition = is_in_code_empty_line }, {
    t("if "),
    i(1),
    t({ " is None:", "\t" }),
    t([[raise ValueError("Expected ']]),
    rep(1),
    t([[' to be not None")]]),
  }),
  s({ trig = "if isinstance .. raise ..", show_condition = is_in_code_empty_line }, {
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
  s({ trig = "if not isinstance .. raise ..", show_condition = is_in_code_empty_line }, {
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
  s({ trig = 'if .. "__main__"', show_condition = is_in_code_empty_line }, {
    t({ 'if __name__ == "__main__":', "\t" }),
    c(1, { i(1), sn(nil, { t("main("), i(1), t(")") }), t(todo), t("pass") }),
  }),

  -- Inline version
  s({ trig = "if .. else ..", show_condition = is_in_code_inline }, {
    t("if "),
    i(1),
    t(" else "),
    c(2, { i(1), t("True"), t("False"), t("None") }),
  }),

  -- [[ for ]]
  -- Block version
  s({ trig = "for .. in ..", show_condition = is_in_code_empty_line }, {
    t("for "),
    i(1),
    t(" in "),
    i(2),
    t({ ":", "\t" }),
    c(3, { i(1), t(todo), t("pass") }),
  }),
  s({ trig = "async for .. in ..", show_condition = is_in_code_empty_line }, {
    t("async for "),
    i(1),
    t(" in "),
    i(2),
    t({ ":", "\t" }),
    c(3, { i(1), t(todo), t("pass") }),
  }),
  s({ trig = "for .. enumerate ..", show_condition = is_in_code_empty_line }, {
    t("for "),
    i(1, "i"),
    t(", "),
    i(2, "x"),
    t(" in enumerate("),
    i(3),
    t({ "):", "\t" }),
    c(4, { i(1), t(todo), t("pass") }),
  }),
  s({ trig = "for .. range ..", show_condition = is_in_code_empty_line }, {
    t("for "),
    i(1, "i"),
    t(" in range("),
    i(2),
    t({ "):", "\t" }),
    c(3, { i(1), t(todo), t("pass") }),
  }),
  s({ trig = "for .. zip ..", show_condition = is_in_code_empty_line }, {
    t("for "),
    i(1, "x"),
    t(", "),
    i(2, "y"),
    t(" in zip("),
    i(3),
    t({ "):", "\t" }),
    c(4, { i(1), t(todo), t("pass") }),
  }),
  -- Inline version
  s({ trig = "for .. in ..", show_condition = is_in_code_inline }, {
    t("for "),
    i(1),
    t(" in "),
    i(2),
  }),
  s({ trig = "for .. enumerate ..", show_condition = is_in_code_inline }, {
    t("for "),
    i(1, "i"),
    t(", "),
    i(2, "x"),
    t(" in enumerate("),
    i(3),
    t(")"),
  }),
  s({ trig = "for .. range ..", show_condition = is_in_code_inline }, {
    t("for "),
    i(1, "i"),
    t(" in range("),
    i(2),
    t(")"),
  }),
  s({ trig = "for .. zip ..", show_condition = is_in_code_inline }, {
    t("for "),
    i(1, "x"),
    t(", "),
    i(2, "y"),
    t(" in zip("),
    i(3),
    t(")"),
  }),

  -- [[ while ]]
  s({ trig = "while ..", show_condition = is_in_code_empty_line }, {
    t("while "),
    c(1, { i(1), t("true") }),
    t({ ":", "\t" }),
    c(2, { i(1), t(todo), t("pass") }),
  }),

  -- [[ raise ]]
  s({ trig = "raise ..", show_condition = is_in_code_empty_line }, {
    t("raise "),
    c(1, { i(1), t("ValueError"), t("TypeError"), t("Exception"), t("NotImplementedError") }),
    c(2, {
      i(1),
      sn(nil, { t('(f"'), i(1), t('")') }), -- f-string can converted back to normal string by ruff
    }),
  }),

  -- [[ try ]]
  s({ trig = "try ..", show_condition = is_in_code_empty_line }, {
    t({ "try:", "\t" }),
    c(1, { i(1), t(todo), t("pass") }),
    t({ "", "except " }),
    c(2, { i(1), sn(nil, { i(1), t(" as "), i(2) }) }),
    t({ ":", "\t" }),
    c(3, { i(1), t(todo), t("pass") }),
  }),

  -- [[ def ]]
  s({ trig = "def ..", show_condition = is_in_code_empty_line }, {
    t("def "),
    d(1, def_dymamic_name),
    t("("),
    d(2, def_nynamic_args),
    t(")"),
    c(3, { sn(nil, { t(" -> "), i(1) }), sn(nil, { t(" -> "), i(1, "None") }), sn(nil, { i(1) }) }),
    t({ ":", "\t" }),
    c(4, { i(1), t(todo), t("pass") }),
  }),
  s({ trig = "async def ..", show_condition = is_in_code_empty_line }, {
    t("async def "),
    d(1, def_dymamic_name),
    t("("),
    d(2, def_nynamic_args),
    t(")"),
    c(3, { sn(nil, { t(" -> "), i(1) }), sn(nil, { t(" -> "), i(1, "None") }), sn(nil, { i(1) }) }),
    t({ ":", "\t" }),
    c(4, { i(1), t(todo), t("pass") }),
  }),

  -- [[ lambda ]]
  s({ trig = "lambda ..", show_condition = is_in_code_inline }, {
    t("lambda "),
    i(1, "x"),
    t(": "),
    i(2, "pass"),
  }),

  -- [[ class ]]
  s({ trig = "class ..", show_condition = is_in_code_empty_line }, {
    t("class "),
    c(1, { i(1, "Name"), sn(nil, { i(1, "Name"), t("("), i(2, "Parent"), t(")") }) }),
    t({ ":", "\t" }),
    c(2, { i(1), t(todo), t("pass") }),
  }),
}
