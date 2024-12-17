local conds = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")
local ls_show_conds = require("luasnip.extras.conditions.show")

local c = ls.choice_node
local i = ls.insert_node
local r = ls.restore_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

return {
  s({
    trig = "else",
    show_condition = conds.line_begin * ls_show_conds.line_end * conds.make_treesitter_node_exclusion_condition({
      "comment",
      "comment_content",
      "string",
      "string_content",
      "table_constructor",
    }),
    desc = [[`else ..`]],
  }, {
    t({ "else", "\t" }),
    i(1),
  }),

  s({
    trig = "elseif",
    show_condition = conds.line_begin * ls_show_conds.line_end * conds.make_treesitter_node_exclusion_condition({
      "comment",
      "comment_content",
      "string",
      "string_content",
      "table_constructor",
    }),
    desc = [[`elseif <../not ..> then ..`]],
  }, {
    t("elseif "),
    c(1, { r(1, "condition", i(nil)), sn(nil, { t("not "), r(1, "condition") }) }),
    t({ " then", "\t" }),
    i(2),
  }),

  s({
    trig = "for",
    show_condition = conds.line_begin * ls_show_conds.line_end * conds.make_treesitter_node_exclusion_condition({
      "comment",
      "comment_content",
      "string",
      "string_content",
      "table_constructor",
    }),
    desc = [[
Choices:
- `for .. do .. end`
- `for .., .. in pairs(..) do .. end`
- `for .., .. in ipairs(..) do .. end`
- `for .. = .., .. do .. end`]],
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
    trig = "function",
    show_condition = conds.make_treesitter_node_exclusion_condition({
      "comment",
      "comment_content",
      "string",
      "string_content",
    }),
    desc = [[
Choices:
- Regular
- Inline]],
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
    trig = "if",
    show_condition = conds.line_begin * ls_show_conds.line_end * conds.make_treesitter_node_exclusion_condition({
      "comment",
      "comment_content",
      "string",
      "string_content",
      "table_constructor",
    }),
    desc = [[`if <../not ..> then .. end`]],
  }, {
    t("if "),
    c(1, { r(1, "condition", i(nil)), sn(nil, { t("not "), r(1, "condition") }) }),
    t({ " then", "\t" }),
    i(2),
    t({ "", "end" }),
  }),

  s({
    trig = "local",
    show_condition = conds.line_begin * conds.make_treesitter_node_exclusion_condition({
      "comment",
      "comment_content",
      "string",
      "string_content",
      "table_constructor",
    }),
    desc = [[
Choices:
- `local .. = <../require("..")>`
- `local function() .. end`]],
  }, {
    t("local "),
    c(1, {
      sn(nil, {
        i(1),
        t(" = "),
        c(2, {
          i(1),
          sn(nil, { t('require("'), i(1), t('")') }),
        }),
      }),
      sn(nil, {
        t("function("),
        i(1),
        t({ ")", "\t" }),
        i(2),
        t({ "", "end" }),
      }),
    }),
  }),

  s({
    trig = "while",
    show_condition = conds.line_begin * ls_show_conds.line_end * conds.make_treesitter_node_exclusion_condition({
      "comment",
      "comment_content",
      "string",
      "string_content",
      "table_constructor",
    }),
    desc = [[`while <../not ..> do .. end`]],
  }, {
    t("while "),
    c(1, { r(1, "condition", i(nil)), sn(nil, { t("not "), r(1, "condition") }) }),
    t({ " do", "\t" }),
    i(2),
    t({ "", "end" }),
  }),
}
