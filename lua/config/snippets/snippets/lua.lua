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
  }, {
    t("else "),
    i(1),
  }),

  s({
    trig = "elseif",
    show_condition = local_conds.in_empty_code_line,
    desc = [[`elseif <…/not …> then …`]],
  }, {
    t("elseif "),
    c(1, {
      r(nil, "cond", i(nil)),
      sn(nil, { t("not "), r(1, "cond") }),
    }),
    t({ " then", "\t" }),
    i(2),
  }),

  s({
    trig = "for",
    show_condition = local_conds.in_empty_code_line,
    desc = [[`for .. do .. end`]],
  }, {
    t("for "),
    i(1),
    t({ " do", "\t" }),
    i(2),
    t({ "", "end" }),
  }),

  s({
    trig = "function",
    show_condition = local_conds.in_code,
    desc = [[`function …() … end`]],
  }, {
    t("function "),
    i(1),
    t("("),
    i(2),
    t({ ")", "\t" }),
    i(3),
    t({ "", "end" }),
  }),

  s({
    trig = "if",
    show_condition = local_conds.in_empty_code_line,
    desc = [[`if <…/not …> then … end`]],
  }, {
    t("if "),
    c(1, {
      r(nil, "cond", i(nil)),
      sn(nil, { t("not "), r(1, "cond") }),
    }),
    t({ " then", "\t" }),
    i(2),
    t({ "", "end" }),
  }),

  s({
    trig = "local",
    show_condition = local_conds.in_empty_code_line,
    desc = [[Choices:
- `local … = <…/require("…")>`
- `local function …() … end`
- `local …`]],
  }, {
    t("local "),
    c(1, {
      sn(nil, {
        r(1, "name", i(nil)),
        t(" = "),
        c(2, { r(nil, "content", i(nil)), sn(nil, { t('require("'), r(1, "content"), t('")') }) }),
      }),
      sn(nil, {
        t("function "),
        r(1, "name"),
        t("("),
        i(2),
        t({ ")", "\t" }),
        i(3),
        t({ "", "end" }),
      }),
      r(nil, "name"),
    }),
  }),

  s({
    trig = "while",
    show_condition = local_conds.in_empty_code_line,
    desc = [[`while <…/not …> do … end`]],
  }, {
    t("while "),
    c(1, {
      r(nil, "cond", i(nil)),
      sn(nil, { t("not "), r(1, "cond") }),
    }),
    t({ " do", "\t" }),
    i(2),
    t({ "", "end" }),
  }),
}
