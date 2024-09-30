local custom_conditions = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")

local c = ls.choice_node
local i = ls.insert_node
local r = ls.restore_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

return {
  s({
    trig = "else ..",
    show_condition = custom_conditions.is_in_code_empty_line,
    docstring = [[
else
  ..]],
  }, {
    t({ "else", "\t" }),
    i(1),
  }),

  s({
    trig = "elsif ..",
    show_condition = custom_conditions.is_in_code_empty_line,
    docstring = [[
Multiple-choice snippet:
- elseif .. then
  ..
end
- elseif not .. then
  ..
end]],
  }, {
    c(1, {
      sn(nil, {
        t("elseif "),
        r(1, "condition", i(nil)),
        t({ " then", "\t" }),
        r(2, "content", i(nil)),
        t({ "", "end" }),
      }),
      sn(nil, {
        t("elseif not "),
        r(1, "condition"),
        t({ " then", "\t" }),
        r(2, "content"),
        t({ "", "end" }),
      }),
    }),
  }),

  s({
    trig = "for ..",
    show_condition = custom_conditions.is_in_code_empty_line,
    docstring = [[
Multiple-choice snippet:
- for .. do
    ..
  end
- for .., .. in pairs(..)
    ..
  end
- for .., .. in ipairs(..)
    ..
  end
- for .. = .., .. do
    ..
  end]],
  }, {
    c(1, {
      sn(nil, {
        t("for "),
        i(1),
        t({ " do", "\t" }),
        r(2, "content", i(nil)),
        t({ "", "end" }),
      }),
      sn(nil, {
        t("for "),
        i(1, "k"),
        t(", "),
        i(2, "v"),
        t(" in pairs("),
        i(3, "t"),
        t({ ") do", "\t" }),
        r(4, "content"),
        t({ "", "end" }),
      }),
      sn(nil, {
        t("for "),
        i(1, "_"),
        t(", "),
        i(2, "x"),
        t(" in ipairs("),
        i(3, "t"),
        t({ ") do", "\t" }),
        r(4, "content"),
        t({ "", "end" }),
      }),
      sn(nil, {
        t("for "),
        i(1, "i"),
        t(" = "),
        i(2, "start"),
        t(", "),
        i(3, "end_"),
        t({ " do", "\t" }),
        r(4, "content"),
        t({ "", "end" }),
      }),
    }),
  }),

  s({
    trig = "function ..",
    show_condition = custom_conditions.is_in_code,
    docstring = [[
Multiple-choice snippet:
- function ..(..)
    ..
  end
- function ..(..) .. end]],
  }, {
    c(1, {
      sn(nil, {
        t("function "),
        r(1, "function_name", i(nil)),
        t("("),
        r(2, "args", i(nil)),
        t({ ")", "\t" }),
        r(3, "content", i(nil)),
        t({ "", "end" }),
      }),
      sn(nil, {
        t("function "),
        r(1, "function_name"),
        t("("),
        r(2, "args"),
        t(") "),
        r(3, "content"),
        t(" end"),
      }),
    }),
  }),

  s({
    trig = "if ..",
    show_condition = custom_conditions.is_in_code_empty_line,
    docstring = [[
Multiple-choice snippet:
- if .. then
  ..
end
- if not .. then
  ..
end]],
  }, {
    c(1, {
      sn(nil, { t("if "), r(1, "condition", i(nil)), t({ " then", "\t" }), r(2, "content", i(nil)), t({ "", "end" }) }),
      sn(nil, { t("if not "), r(1, "condition"), t({ " then", "\t" }), r(2, "content"), t({ "", "end" }) }),
    }),
  }),

  s({
    trig = "local ..",
    show_condition = custom_conditions.is_in_code_line_begin,
    docstring = [[
Multiple-choice snippet:
- local ..
- local .. = ..
- local .. = require("..")]],
  }, {
    c(1, {
      sn(nil, { t("local "), r(1, "var_name", i(nil)) }),
      sn(nil, { t("local "), r(1, "var_name"), t(" = "), i(2) }),
      sn(nil, { t("local "), r(1, "var_name"), t([[ = require("]]), i(2), t([[")]]) }),
    }),
  }),

  s({
    trig = "while ..",
    show_condition = custom_conditions.is_in_code_empty_line,
    docstring = [[
Multiple-choice snippet:
- while .. do
  ..
end
- while not .. do
  ..
end]],
  }, {
    c(1, {
      sn(nil, {
        t("while "),
        r(1, "condition", i(nil)),
        t({ " do", "\t" }),
        r(2, "content", i(nil)),
        t({ "", "end" }),
      }),
      sn(nil, {
        t("while not "),
        r(1, "condition"),
        t({ " do", "\t" }),
        r(2, "content"),
        t({ "", "end" }),
      }),
    }),
  }),
}
