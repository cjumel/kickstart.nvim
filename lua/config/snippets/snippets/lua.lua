local conds = require("config.snippets.conditions")

local ls = require("luasnip")

local c = ls.choice_node
local i = ls.insert_node
local r = ls.restore_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local local_conds = {}
local_conds.in_code = conds.make_ts_node_not_in_condition({
  "comment",
  "comment_content",
  "string",
  "string_content",
})
local_conds.in_empty_code_line = conds.line_begin * conds.line_end * local_conds.in_code

return {

  s({
    trig = "else", -- For consistency with if and elseif snippets
    show_condition = local_conds.in_empty_code_line,
    desc = [[`else …`]],
  }, { t("else "), i(1) }),

  s({
    trig = "elseif",
    show_condition = local_conds.in_empty_code_line,
    desc = [[Choices:
- `elseif … then …`
- `elseif not … then …`]],
  }, {
    c(1, {
      sn(nil, { t("elseif "), r(1, "cond", i(nil)), t({ " then", "\t" }), r(2, "content", i(nil)) }),
      sn(nil, { t("elseif not "), r(1, "cond"), t({ " then", "\t" }), r(2, "content") }),
    }),
  }),

  s({
    trig = "for",
    show_condition = local_conds.in_empty_code_line,
    desc = [[`for .. do .. end`]],
  }, { t("for "), i(1), t({ " do", "\t" }), i(2), t({ "", "end" }) }),

  s({
    trig = "function",
    show_condition = local_conds.in_code,
    desc = [[Choices:
- multiline
- inline]],
  }, {
    c(1, {
      sn(nil, {
        t("function "),
        r(1, "name", i(nil)),
        t("("),
        r(2, "args", i(nil)),
        t({ ")", "\t" }),
        r(3, "content", i(nil)),
        t({ "", "end" }),
      }),
      sn(nil, {
        t("function "),
        r(1, "name"),
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
    show_condition = local_conds.in_empty_code_line,
    desc = [[Choices:
- `if … then … end`
- `if not … then … end`]],
  }, {
    c(1, {
      sn(nil, { t("if "), r(1, "cond", i(nil)), t({ " then", "\t" }), r(2, "content", i(nil)), t({ "", "end" }) }),
      sn(nil, { t("if not "), r(1, "cond"), t({ " then", "\t" }), r(2, "content"), t({ "", "end" }) }),
    }),
  }),

  s({
    trig = "local",
    show_condition = local_conds.in_empty_code_line,
    desc = [[`local …`]],
  }, { t("local ") }),
  s({
    trig = "local function",
    show_condition = local_conds.in_empty_code_line,
    desc = [[Choices:
- multiline
- inline]],
  }, {
    c(1, {
      sn(nil, {
        t("local function "),
        r(1, "name", i(nil)),
        t("("),
        r(2, "args", i(nil)),
        t({ ")", "\t" }),
        r(3, "content", i(nil)),
        t({ "", "end" }),
      }),
      sn(nil, {
        t("local function "),
        r(1, "name"),
        t("("),
        r(2, "args"),
        t(") "),
        r(3, "content"),
        t(" end"),
      }),
    }),
  }),
  s({
    trig = "local … require",
    show_condition = local_conds.in_empty_code_line,
    desc = [[`local … = require("…")`]],
  }, { t("local "), i(1), t(' = require("'), i(2), t('")') }),

  s({
    trig = "while",
    show_condition = local_conds.in_empty_code_line,
    desc = [[Choices:
- `while … do … end`
- `while not … do … end`]],
  }, {
    c(1, {
      sn(nil, { t("while "), r(1, "cond", i(nil)), t({ " do", "\t" }), r(2, "content", i(nil)), t({ "", "end" }) }),
      sn(nil, { t("while not "), r(1, "cond"), t({ " do", "\t" }), r(2, "content"), t({ "", "end" }) }),
    }),
  }),
}
