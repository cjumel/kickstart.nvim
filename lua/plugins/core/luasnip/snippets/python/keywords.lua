local conds = require("plugins.core.luasnip.conditions")

local ls = require("luasnip")
local ls_extras = require("luasnip.extras")
local ls_show_conds = require("luasnip.extras.conditions.show")

local c = ls.choice_node
local i = ls.insert_node
local r = ls.restore_node
local rep = ls_extras.rep
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local local_conds = {}
local_conds.in_code = conds.ts_node_not_in({ "comment", "string", "string_start", "string_content", "string_end" })
local_conds.async = conds.prefix("async ")
local_conds.for_inline = conds.ts_node_in({ "dictionary", "list", "set" })

return {
  s({
    trig = "def",
    show_condition = (conds.line_begin + local_conds.async) * ls_show_conds.line_end * local_conds.in_code,
    desc = [[`def …(…) -> …: …`]],
  }, {
    t("def "),
    c(1, {
      r(1, "name", i(nil)),
      sn(nil, { t("__"), r(1, "name"), t("__") }),
    }),
    t("("),
    c(2, {
      r(1, "args", i(nil)),
      sn(nil, { t("self"), r(1, "args") }),
      sn(nil, { t("cls"), r(1, "args") }),
    }),
    t(") -> "),
    c(3, {
      i(1),
      sn(nil, { t("None"), i(1) }),
    }),
    t({ ":", "\t" }),
    c(4, {
      i(1),
      sn(nil, { t("pass"), i(1) }),
    }),
  }),

  s({
    trig = "for",
    show_condition = (conds.line_begin + local_conds.async)
      * ls_show_conds.line_end
      * local_conds.in_code
      * -local_conds.for_inline,
    desc = [[`for … in …: …`]],
  }, {
    t("for "),
    i(1),
    t(" in "),
    i(2),
    t({ ":", "\t" }),
    i(3),
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
    trig = "for … enumerate",
    show_condition = (conds.line_begin + local_conds.async)
      * ls_show_conds.line_end
      * local_conds.in_code
      * -local_conds.for_inline,
    desc = [[`for … in enumerate(…): …`]],
  }, {
    t("for "),
    i(1),
    t(", "),
    i(2),
    t(" in enumerate("),
    i(3),
    t({ "):", "\t" }),
    i(4),
  }),
  s({
    trig = "for … enumerate", -- Inline version
    show_condition = local_conds.for_inline,
    desc = [[`for … in enumerate(…)`]],
  }, {
    t("for "),
    i(1),
    t(", "),
    i(2),
    t(" in enumerate("),
    i(3),
    t(")"),
  }),
  s({
    trig = "for … range",
    show_condition = (conds.line_begin + local_conds.async)
      * ls_show_conds.line_end
      * local_conds.in_code
      * -local_conds.for_inline,
    desc = [[`for … in range(…): …`]],
  }, {
    t("for "),
    i(1),
    t(" in range("),
    i(2),
    t({ "):", "\t" }),
    i(3),
  }),
  s({
    trig = "for … range", -- Inline version
    show_condition = local_conds.for_inline,
    desc = [[`for … in range(…)`]],
  }, {
    t("for "),
    i(1),
    t(" in range("),
    i(2),
    t(")"),
  }),
  s({
    trig = "for … zip",
    show_condition = (conds.line_begin + local_conds.async)
      * ls_show_conds.line_end
      * local_conds.in_code
      * -local_conds.for_inline,
    desc = [[`for … in zip(…): …`]],
  }, {
    t("for "),
    i(1),
    t(" in zip("),
    i(2),
    t({ "):", "\t" }),
    i(3),
  }),
  s({
    trig = "for … zip", -- Inline version
    show_condition = local_conds.for_inline,
    desc = [[`for … in zip(…)`]],
  }, {
    t("for "),
    i(1),
    t(" in zip("),
    i(2),
    t(")"),
  }),

  s({
    trig = "from … import",
    show_condition = conds.line_begin * ls_show_conds.line_end * local_conds.in_code,
    desc = [[`from … import …`]],
  }, {
    t("from "),
    i(1),
    t(" import "),
    i(2),
  }),
  s({
    trig = "from … import … as",
    show_condition = conds.line_begin * ls_show_conds.line_end * local_conds.in_code,
    desc = [[`from … import … as`]],
  }, {
    t("from "),
    i(1),
    t(" import "),
    i(2),
    t(" as "),
    i(3),
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
    show_condition = conds.line_begin * ls_show_conds.line_end * conds.ts_node_in({ "module" }),
    desc = [[`if __name__ == "__main__": …`]],
  }, {
    t({ 'if __name__ == "__main__":', "\t" }),
    i(1),
  }),
  s({
    trig = "if … isinstance … raise",
    show_condition = conds.line_begin * ls_show_conds.line_end * local_conds.in_code,
    desc = [[
Choices:
- `if isinstance(…): raise TypeError(…)`
- `if not isinstance(…): raise TypeError(…)`]],
  }, {
    c(1, {
      sn(nil, {
        t("if isinstance("),
        r(1, "variable", i(nil)),
        t(", "),
        r(2, "type", i(nil)),
        t({ "):", "\t" }),
        t([[raise TypeError("Expected ']]),
        rep(1),
        t([[' not to be of type ']]),
        rep(2),
        t([['")]]),
        i(3), -- To be able to switch choice node while at the end
      }),
      sn(nil, {
        t("if not isinstance("),
        r(1, "variable"),
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
        i(3), -- To be able to switch choice node while at the end
      }),
    }),
  }),
  s({
    trig = "if … None … raise",
    show_condition = conds.line_begin * ls_show_conds.line_end * local_conds.in_code,
    desc = [[
Choices:
- `if … is None: raise ValueError(…)`
- `if … is not None: raise ValueError(…)`]],
  }, {
    c(1, {
      sn(nil, {
        t("if "),
        r(1, "variable", i(nil)),
        t({ " is None:", "\t" }),
        t([[raise ValueError("Expected ']]),
        rep(1),
        t([[' not to be None")]]),
        i(2),
      }),
      sn(nil, {
        t("if "),
        r(1, "variable"),
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
    show_condition = conds.line_begin * ls_show_conds.line_end * local_conds.in_code,
    desc = [[`import …`]],
  }, {
    t("import "),
    i(1),
  }),
  s({
    trig = "import … as",
    show_condition = conds.line_begin * ls_show_conds.line_end * local_conds.in_code,
    desc = [[`import … as …`]],
  }, {
    t("import "),
    i(1),
    t(" as "),
    i(2),
  }),

  s({
    trig = "or None",
    show_condition = -conds.line_begin
      * conds.ts_node_in({ "module", "block", "parameters", "typed_default_parameter" }),
    desc = [[`| None`]],
  }, {
    c(1, {
      sn(nil, { t("| None"), i(1) }),
      sn(nil, { t("| None = None"), i(1) }),
    }),
  }),
}
