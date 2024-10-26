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

return {

  s({
    trig = "class ..",
    show_condition = conds.line_begin * ls_show_conds.line_end * conds.make_treesitter_node_exclusion_condition({
      "comment",
      "string",
      "string_start",
      "string_content",
      "string_end",
    }),
    desc = [[
Choices:
- `class ..: <../pass>`
- `class ..(..): <../pass>`]],
  }, {
    c(1, {
      sn(nil, {
        t("class "),
        r(1, "name", i(nil)),
        t({ ":", "\t" }),
        r(2, "body", c(nil, { i(nil), sn(nil, { t("pass"), i(1) }) })),
      }),
      sn(nil, {
        t("class "),
        r(1, "name"),
        t("("),
        i(2),
        t({ "):", "\t" }),
        r(3, "body"),
      }),
    }),
  }),

  s({
    trig = "def ..",
    show_condition = (conds.line_begin + conds.make_prefix_condition("async "))
      * ls_show_conds.line_end
      * conds.make_treesitter_node_exclusion_condition({
        "comment",
        "string",
        "string_start",
        "string_content",
        "string_end",
      })
      -- Exclude cases where the method version should be used instead
      * ( -- Inside a class definition can correspond to "class_definition" nodes (top of class body), or "block"
        conds.make_treesitter_node_exclusion_condition({ "class_definition" })
        * conds.make_treesitter_node_ancestors_exclusion_condition({ "block", "class_definition" })
      ),
    desc = [[`def ..(..) -> <../None/Any>: <../pass>`]],
  }, {
    t("def "),
    i(1),
    t("("),
    i(2),
    t(") -> "),
    c(3, { i(nil), sn(nil, { t("None"), i(1) }), sn(nil, { t("Any"), i(1) }) }),
    t({ ":", "\t" }),
    c(4, { i(nil), sn(nil, { t("pass"), i(1) }) }),
  }),
  s({
    trig = "def ..", -- Method version
    show_condition = (conds.line_begin + conds.make_prefix_condition("async "))
      * ls_show_conds.line_end
      * conds.make_treesitter_node_exclusion_condition({
        "comment",
        "string",
        "string_start",
        "string_content",
        "string_end",
      })
      * ( -- Inside a class definition can correspond to "class_definition" nodes (top of class body), or "block"
        conds.make_treesitter_node_ancestors_inclusion_condition({ "class_definition" })
        + conds.make_treesitter_node_ancestors_inclusion_condition({ "block", "class_definition" })
      ),
    desc = [[
Choices:
- `def ..(<self../cls../..>) -> <../None/Any>: <../pass>`
- `def __..__(<self..>) -> <../None/Any>: <../pass>`]],
  }, {
    c(1, {
      sn(nil, {
        t("def "),
        r(1, "name", i(nil)),
        t("("),
        c(2, {
          sn(nil, { t("self"), r(1, "args", i(nil)) }),
          sn(nil, { t("cls"), r(1, "args") }),
          r(nil, "args"),
        }),
        t(") -> "),
        r(3, "type", c(nil, { i(nil), sn(nil, { t("None"), i(1) }), sn(nil, { t("Any"), i(1) }) })),
        t({ ":", "\t" }),
        r(4, "body", c(nil, { i(nil), sn(nil, { t("pass"), i(1) }) })),
      }),
      sn(nil, {
        t("def __"),
        r(1, "name"),
        t("__("),
        c(2, {
          sn(nil, { t("self"), r(1, "args") }),
        }),
        t(") -> "),
        r(3, "type"),
        t({ ":", "\t" }),
        r(4, "body"),
      }),
    }),
  }),

  s({
    trig = "elif ..",
    show_condition = conds.line_begin * ls_show_conds.line_end * conds.make_treesitter_node_exclusion_condition({
      "comment",
      "string",
      "string_start",
      "string_content",
      "string_end",
    }),
    desc = [[`elif <../not ..>: <../pass>`]],
  }, {
    t("elif "),
    c(1, { r(nil, "condition", i(nil)), sn(nil, { t("not "), r(1, "condition") }) }),
    t({ ":", "\t" }),
    c(2, { i(nil), sn(nil, { t("pass"), i(1) }) }),
  }),

  s({
    trig = "else ..",
    show_condition = conds.line_begin * ls_show_conds.line_end * conds.make_treesitter_node_exclusion_condition({
      "comment",
      "string",
      "string_start",
      "string_content",
      "string_end",
    }),
    desc = [[`else: <../pass>`]],
  }, {
    t({ "else:", "\t" }),
    c(1, { i(nil), sn(nil, { t("pass"), i(1) }) }),
  }),

  s({
    trig = "except ..",
    show_condition = conds.line_begin * ls_show_conds.line_end * conds.make_treesitter_node_exclusion_condition({
      "comment",
      "string",
      "string_start",
      "string_content",
      "string_end",
    }),
    desc = [[
Choices:
- `except ..: <../pass>`
- `except .. as ..: <../pass`]],
  }, {
    c(1, {
      sn(nil, {
        t("except "),
        r(1, "error", i(nil)),
        t({ ":", "\t" }),
        r(2, "content", c(nil, { i(nil), sn(nil, { t("pass"), i(1) }) })),
      }),
      sn(nil, {
        t("except "),
        r(1, "error"),
        t(" as "),
        i(2),
        t({ ":", "\t" }),
        r(3, "content"),
      }),
    }),
  }),

  s({
    trig = "finally ..",
    show_condition = conds.line_begin * ls_show_conds.line_end * conds.make_treesitter_node_exclusion_condition({
      "comment",
      "string",
      "string_start",
      "string_content",
      "string_end",
    }),
    desc = [[`finally: <../pass>`]],
  }, {
    t({ "finally:", "\t" }),
    c(1, { i(nil), sn(nil, { t("pass"), i(1) }) }),
  }),

  s({
    trig = "for ..",
    show_condition = (conds.line_begin + conds.make_prefix_condition("async "))
      * ls_show_conds.line_end
      * conds.make_treesitter_node_exclusion_condition({
        "comment",
        "string",
        "string_start",
        "string_content",
        "string_end",
      }),
    desc = [[
Choices:
- `for .. in ..: <../pass>`
- `for .. in enumerate(..): <../pass>`
- `for .. in range(..): <../pass>`
- `for .. in zip(..): <../pass>`]],
  }, {
    c(1, {
      sn(nil, {
        t("for "),
        r(1, "variable", i(nil)),
        t(" in "),
        r(2, "iterable", i(nil)),
        t({ ":", "\t" }),
        r(3, "content", c(nil, { i(nil), sn(nil, { t("pass"), i(1) }) })),
      }),
      sn(nil, {
        t("for "),
        i(1),
        t(", "),
        r(2, "variable"),
        t(" in enumerate("),
        r(3, "iterable"),
        t({ "):", "\t" }),
        r(4, "content"),
      }),
      sn(nil, {
        t("for "),
        r(1, "variable"),
        t(" in range("),
        r(2, "iterable"),
        t({ "):", "\t" }),
        r(3, "content"),
      }),
      sn(nil, {
        t("for "),
        r(1, "variable"),
        t(", "),
        i(2),
        t(" in zip("),
        r(3, "iterable"),
        t(", "),
        i(4),
        t({ "):", "\t" }),
        r(5, "content"),
      }),
    }),
  }),
  s({
    trig = "for ..", -- Inline version
    show_condition = -(conds.line_begin + conds.make_prefix_condition("async "))
      * conds.make_treesitter_node_exclusion_condition({
        "comment",
        "string",
        "string_start",
        "string_content",
        "string_end",
      }),
    desc = [[
Choices:
- `for .. in ..`
- `for .. in enumerate(..)`
- `for .. in range(..)`
- `for .. in zip(..)`]],
  }, {
    c(1, {
      sn(nil, {
        t("for "),
        r(1, "variable", i(nil)),
        t(" in "),
        r(2, "iterable", i(nil)),
      }),
      sn(nil, {
        t("for "),
        i(1),
        t(", "),
        r(2, "variable"),
        t(" in enumerate("),
        r(3, "iterable"),
        t(")"),
      }),
      sn(nil, {
        t("for "),
        r(1, "variable"),
        t(" in range("),
        r(2, "iterable"),
        t(")"),
      }),
      sn(nil, {
        t("for "),
        r(1, "variable"),
        t(", "),
        i(2),
        t(" in zip("),
        r(3, "iterable"),
        t(", "),
        i(4),
        t(")"),
      }),
    }),
  }),

  s({
    trig = "from ..",
    show_condition = conds.line_begin * ls_show_conds.line_end * conds.make_treesitter_node_exclusion_condition({
      "comment",
      "string",
      "string_start",
      "string_content",
      "string_end",
    }),
    desc = [[
Choices:
- `from .. import ..`
- `from .. import .. as ..`]],
  }, {
    c(1, {
      sn(nil, {
        t("from "),
        r(1, "module", i(nil)),
        t(" import "),
        r(2, "content", i(nil)),
      }),
      sn(nil, {
        t("from "),
        r(1, "module"),
        t(" import "),
        r(2, "content"),
        t(" as "),
        i(3),
      }),
    }),
  }),

  s({
    trig = "if ..",
    show_condition = conds.line_begin * ls_show_conds.line_end * conds.make_treesitter_node_exclusion_condition({
      "comment",
      "string",
      "string_start",
      "string_content",
      "string_end",
    }),
    desc = [[`if <../not ..>: <../pass>`]],
  }, {
    t("if "),
    c(1, { r(nil, "condition", i(nil)), sn(nil, { t("not "), r(1, "condition") }) }),
    t({ ":", "\t" }),
    c(2, { i(nil), sn(nil, { t("pass"), i(1) }) }),
  }),
  s({
    trig = "if ..", -- Inline version
    show_condition = -conds.line_begin * conds.make_treesitter_node_exclusion_condition({
      "comment",
      "string",
      "string_start",
      "string_content",
      "string_end",
    }),
    desc = [[`if <../not ..> else <../None>`]],
  }, {
    t("if "),
    c(1, { r(nil, "condition", i(nil)), sn(nil, { t("not "), r(1, "condition") }) }),
    t(" else "),
    c(2, { i(nil), sn(nil, { t("None"), i(1) }) }),
  }),

  s({
    trig = "if .. main ..",
    show_condition = conds.line_begin * ls_show_conds.line_end * conds.make_treesitter_node_exclusion_condition({
      "comment",
      "string",
      "string_start",
      "string_content",
      "string_end",
    }),
    desc = [[`if __name__ == "__main__": <../pass>`]],
  }, {
    t({ 'if __name__ == "__main__":', "\t" }),
    c(1, { i(nil), sn(nil, { t("pass"), i(1) }) }),
  }),

  s({
    trig = "if .. raise ..",
    show_condition = conds.line_begin * ls_show_conds.line_end * conds.make_treesitter_node_exclusion_condition({
      "comment",
      "string",
      "string_start",
      "string_content",
      "string_end",
    }),
    desc = [[
Choices:
- `if .. is None: raise ValueError(..)`
- `if .. is not None: raise ValueError(..)`
- `if isinstance(..): raise TypeError(..)`
- `if not isinstance(..): raise TypeError(..)`]],
  }, {
    c(1, {
      sn(nil, {
        t("if "),
        r(1, "variable", i(nil)),
        t({ " is None:", "\t" }),
        t([[raise ValueError("Expected ']]),
        rep(1),
        t([[' to be not None")]]),
        i(2),
      }),
      sn(nil, {
        t("if "),
        r(1, "variable"),
        t({ " is not None:", "\t" }),
        t([[raise ValueError("Expected ']]),
        rep(1),
        t([[' to be None")]]),
        i(2),
      }),
      sn(nil, {
        t("if isinstance("),
        r(1, "variable"),
        t(", "),
        r(2, "type", i(nil)),
        t({ "):", "\t" }),
        t([[raise TypeError("Expected ']]),
        rep(1),
        t([[' not to be of type ']]),
        rep(2),
        t([['")]]),
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
      }),
    }),
  }),

  s({
    trig = "import ..",
    show_condition = conds.line_begin * ls_show_conds.line_end * conds.make_treesitter_node_exclusion_condition({
      "comment",
      "string",
      "string_start",
      "string_content",
      "string_end",
    }),
    desc = [[
Choices:
- `import ..`
- `import .. as ..`]],
  }, {
    c(1, {
      sn(nil, { t("import "), r(1, "module", i(nil)) }),
      sn(nil, { t("import "), r(1, "module"), t(" as "), i(2) }),
    }),
  }),

  s({
    trig = "raise ..",
    show_condition = conds.line_begin * ls_show_conds.line_end * conds.make_treesitter_node_exclusion_condition({
      "comment",
      "string",
      "string_start",
      "string_content",
      "string_end",
    }),
    desc = [[
Choices:
- `raise ..`
- `raise Exception`]],
  }, {
    c(1, {
      sn(nil, { t("raise "), i(1) }),
      sn(nil, { t("raise Exception"), i(1) }),
    }),
  }),

  s({
    trig = "try ..",
    show_condition = conds.line_begin * ls_show_conds.line_end * conds.make_treesitter_node_exclusion_condition({
      "comment",
      "string",
      "string_start",
      "string_content",
      "string_end",
    }),
    desc = [[`try: <../pass>`]],
  }, {
    t({ "try:", "\t" }),
    c(1, { i(nil), sn(nil, { t("pass"), i(1) }) }),
  }),

  s({
    trig = "while ..",
    show_condition = conds.line_begin * ls_show_conds.line_end * conds.make_treesitter_node_exclusion_condition({
      "comment",
      "string",
      "string_start",
      "string_content",
      "string_end",
    }),
    desc = [[`while <../not ..>: <../pass>`]],
  }, {
    t("while "),
    c(1, { r(nil, "condition", i(nil)), sn(nil, { t("not "), r(1, "condition") }) }),
    t({ ":", "\t" }),
    c(2, { i(nil), sn(nil, { t("pass"), i(1) }) }),
  }),
}
