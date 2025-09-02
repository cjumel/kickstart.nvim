local conds = require("config.snippets.conditions")

local ls = require("luasnip")
local ls_extras = require("luasnip.extras")

local c = ls.choice_node
local i = ls.insert_node
local r = ls.restore_node
local rep = ls_extras.rep
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local local_conds = {}
local_conds.in_code =
  conds.make_ts_node_not_in_condition({ "comment", "string", "string_start", "string_content", "string_end" })
local_conds.async = conds.make_prefix_condition("async ")
local_conds.for_inline = conds.make_ts_node_in_condition({ "dictionary", "list", "set" })
local_conds.in_comment = conds.make_ts_node_in_condition({ "comment" })
local_conds.in_module = conds.make_ts_node_in_condition({ "module" })

return {

  -- [[ Code keywords ]]

  s({
    trig = "def",
    show_condition = (conds.line_begin + local_conds.async) * conds.line_end * local_conds.in_code,
    desc = [[`def <…/__…__/test_…>(<…/self…/cls…>) -> …: …`]],
  }, {
    t("def "),
    c(1, {
      r(nil, "name", i(nil)),
      sn(nil, { t("__"), r(1, "name"), t("__") }),
      sn(nil, { t("test_"), r(1, "name") }),
    }),
    t("("),
    c(2, {
      i(nil),
      sn(nil, { t("self"), i(1) }),
      sn(nil, { t("cls"), i(1) }),
    }),
    t(") -> "),
    i(3, "None"),
    t({ ":", "\t" }),
    i(4, "pass"),
  }),

  s({
    trig = "elif",
    show_condition = conds.line_begin * conds.line_end * local_conds.in_code,
    desc = [[`elif <…/not …>: …`]],
  }, {
    t("elif "),
    c(1, {
      r(nil, "cond", i(nil)),
      sn(nil, { t("not "), r(1, "cond") }),
    }),
    t({ ":", "\t" }),
    i(2, "pass"),
  }),

  s({
    trig = "else", -- For consistency with if and elseif snippets
    show_condition = conds.line_begin * conds.line_end * local_conds.in_code,
    desc = [[`else: …`]],
  }, {
    t({ "else:", "\t" }),
    i(1, "pass"),
  }),

  s({
    trig = "for",
    show_condition = (conds.line_begin + local_conds.async)
      * conds.line_end
      * local_conds.in_code
      * -local_conds.for_inline,
    desc = [[`for … in …: …`]],
  }, {
    t("for "),
    i(1),
    t(" in "),
    i(2),
    t({ ":", "\t" }),
    i(3, "pass"),
  }),
  s({
    trig = "for", -- Inline version
    show_condition = local_conds.for_inline,
    desc = [[`for … in …`]],
  }, {
    t("for "),
    i(1),
    t(" in "),
    i(2),
  }),

  s({
    trig = "from … import",
    show_condition = conds.line_begin * conds.line_end * local_conds.in_code,
    desc = [[Choices:
- `from … import …`
- `from … import … as …`]],
  }, {
    t("from "),
    c(1, {
      sn(nil, { r(1, "module", i(nil)) }, t(" import "), r(2, "content", i(nil))),
      sn(nil, { r(1, "module"), t(" import "), r(2, "content"), t(" as "), i(3) }),
    }),
  }),

  s({
    trig = "if",
    show_condition = conds.line_begin * conds.line_end * local_conds.in_code,
    desc = [[`if <…/not …>: …`]],
  }, {
    t("if "),
    c(1, {
      r(nil, "cond", i(nil)),
      sn(nil, { t("not "), r(1, "cond") }),
    }),
    t({ ":", "\t" }),
    i(2, "pass"),
  }),
  s({
    trig = "if … else", -- Inline version
    show_condition = -conds.line_begin * local_conds.in_code,
    desc = [[`if … else …`]],
  }, {
    t("if "),
    i(1),
    t(" else "),
    i(2),
  }),
  s({
    trig = "if … main",
    show_condition = conds.line_begin * conds.line_end * local_conds.in_module,
    desc = [[`if __name__ == "__main__": …`]],
  }, {
    t({ 'if __name__ == "__main__":', "\t" }),
    i(1, "pass"),
  }),
  s({
    trig = "if … isinstance … raise",
    show_condition = conds.line_begin * conds.line_end * local_conds.in_code,
    desc = [[Choices:
- `if isinstance(…): raise TypeError(…)`
- `if not isinstance(…): raise TypeError(…)`]],
  }, {
    c(1, {
      sn(nil, {
        t("if isinstance("),
        r(1, "var", i(nil)),
        t(", "),
        r(2, "type", i(nil)),
        t({ "):", "\t" }),
        t([[raise TypeError("Expected ']]),
        rep(1),
        t([[' not to be of type ']]),
        rep(2),
        t([['")]]),
        i(3),
      }),
      sn(nil, {
        t("if not isinstance("),
        r(1, "var"),
        t(", "),
        r(2, "type"),
        t({ "):", "\t" }),
        t([[raise TypeError(f"Expected ']]),
        rep(1),
        t([[' to be of type ']]),
        rep(2),
        t([[' but got '{type(]]),
        rep(1),
        t([[)}'")]]),
        i(3),
      }),
    }),
  }),
  s({
    trig = "if … None … raise",
    show_condition = conds.line_begin * conds.line_end * local_conds.in_code,
    desc = [[Choices:
- `if … is None: raise ValueError(…)`
- `if … is not None: raise ValueError(…)`]],
  }, {
    c(1, {
      sn(nil, {
        t("if "),
        r(1, "var", i(nil)),
        t({ " is None:", "\t" }),
        t([[raise ValueError("Expected ']]),
        rep(1),
        t([[' not to be None")]]),
        i(2),
      }),
      sn(nil, {
        t("if "),
        r(1, "var"),
        t({ " is not None:", "\t" }),
        t([[raise ValueError(f"Expected ']]),
        rep(1),
        t([[' to be None but got '{]]),
        rep(1),
        t([[}'")]]),
        i(2),
      }),
    }),
  }),

  s({
    trig = "import",
    show_condition = conds.line_begin * conds.line_end * local_conds.in_code,
    desc = [[Choices:
- `import …`
- `import … as …`]],
  }, {
    t("import "),
    c(1, {
      r(nil, "module", i(nil)),
      sn(nil, { r(1, "module"), t(" as "), i(2) }),
    }),
  }),

  s({
    trig = "or None",
    show_condition = -conds.line_begin * conds.make_ts_node_in_condition({
      "assignment",
      "block",
      "constrained_type",
      "function_definition",
      "module",
      "parameters",
      "type_parameter",
      "typed_default_parameter",
    }),
    desc = [[`| None`]],
  }, {
    t("| None"),
    c(1, {
      i(nil),
      sn(nil, { t(" = "), i(1, "None") }),
    }),
  }),

  s({
    trig = "while",
    show_condition = conds.line_begin * conds.line_end * local_conds.in_code,
    desc = [[`while <…/not …>: …`]],
  }, {
    t("while "),
    c(1, {
      r(nil, "cond", i(nil)),
      sn(nil, { t("not "), r(1, "cond") }),
    }),
    t({ ":", "\t" }),
    i(2, "pass"),
  }),

  -- [[ Comment keywords ]]

  s({
    trig = "noqa",
    show_condition = local_conds.in_comment * conds.comment_start * conds.line_end,
    desc = [[Ignore lint warnings (e.g. for Flake8 or Ruff).
Choices:
- `noqa: …`
- `noqa`]],
  }, {
    t("noqa"),
    c(1, {
      sn(nil, { t(": "), i(1) }),
      i(nil),
    }),
  }),

  s({
    trig = "pragma: no cover",
    show_condition = local_conds.in_comment * conds.comment_start * conds.line_end,
    desc = [[Exclude from coverage reports (e.g. for coverage.py or pytest-cov).
`pragma: no cover`]],
  }, {
    t("pragma: no cover"),
  }),

  s({
    trig = "pyright: ignore",
    show_condition = local_conds.in_comment * conds.comment_start * conds.line_end,
    desc = [[Ignore a specific pyright warning.
Choices:
- `pyright: ignore[…]`
- `pyright: ignore`]],
  }, {
    t("pyright: ignore"),
    c(1, {
      sn(nil, { t("["), i(1), t("]") }),
      i(nil),
    }),
  }),

  s({
    trig = "ruff: noqa",
    show_condition = local_conds.in_comment * conds.comment_start * conds.line_end * conds.first_line,
    desc = [[Ignore ruff warnings for the entire file.
Choices:
- `ruff: noqa: …`
- `ruff: noqa`]],
  }, {
    t("ruff: noqa"),
    c(1, {
      sn(nil, { t(": "), i(1) }),
      i(nil),
    }),
  }),

  s({
    trig = "type: ignore",
    show_condition = local_conds.in_comment * conds.comment_start * conds.line_end,
    desc = [[Ignore typing warnings (e.g. for mypy or Pyright).
Choices:
- `type: ignore[…]`
- `type: ignore`]],
  }, {
    t("type: ignore"),
    c(1, {
      sn(nil, { t("["), i(1), t("]") }),
      i(nil),
    }),
  }),
}
