local conds = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")
local ls_show_conds = require("luasnip.extras.conditions.show")

local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

-- Condition to avoid triggering a snippet inside a string or a comment
local is_in_code_condition = conds.make_treesitter_node_exclusion_condition({
  "comment",
  "string",
  "string_start",
  "string_content",
  "string_end",
})

return {
  s({
    trig = "def",
    show_condition = (conds.line_begin + conds.make_prefix_condition("async "))
      * ls_show_conds.line_end
      * is_in_code_condition,
    desc = [[`def ..(..) -> ..: ..`]],
  }, {
    t("def "),
    i(1),
    t("("),
    i(2),
    t(") -> "),
    i(3),
    t({ ":", "\t" }),
    i(4),
  }),

  s({
    trig = "for .. in",
    show_condition = (conds.line_begin + conds.make_prefix_condition("async "))
      * ls_show_conds.line_end
      * is_in_code_condition,
    desc = [[`for .. in ..: ..`]],
  }, {
    t("for "),
    i(1),
    t(" in "),
    i(2),
    t({ ":", "\t" }),
    i(3),
  }),
  s({
    trig = "for .. in", -- Inline version
    show_condition = -(conds.line_begin + conds.make_prefix_condition("async ")) * is_in_code_condition,
    desc = [[`for .. in ..`]],
  }, {
    t("for "),
    i(1),
    t(" in "),
    i(2),
  }),
  s({
    trig = "for .. enumerate",
    show_condition = (conds.line_begin + conds.make_prefix_condition("async "))
      * ls_show_conds.line_end
      * is_in_code_condition,
    desc = [[`for .. in enumerate(..): ..`]],
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
    trig = "for .. enumerate", -- Inline version
    show_condition = -(conds.line_begin + conds.make_prefix_condition("async ")) * is_in_code_condition,
    desc = [[`for .. in enumerate(..)`]],
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
    trig = "for .. range",
    show_condition = (conds.line_begin + conds.make_prefix_condition("async "))
      * ls_show_conds.line_end
      * is_in_code_condition,
    desc = [[`for .. in range(..): ..`]],
  }, {
    t("for "),
    i(1),
    t(" in range("),
    i(2),
    t({ "):", "\t" }),
    i(3),
  }),
  s({
    trig = "for .. range", -- Inline version
    show_condition = -(conds.line_begin + conds.make_prefix_condition("async ")) * is_in_code_condition,
    desc = [[`for .. in range(..)`]],
  }, {
    t("for "),
    i(1),
    t(" in range("),
    i(2),
    t(")"),
  }),
  s({
    trig = "for .. zip",
    show_condition = (conds.line_begin + conds.make_prefix_condition("async "))
      * ls_show_conds.line_end
      * is_in_code_condition,
    desc = [[`for .. in zip(..): ..`]],
  }, {
    t("for "),
    i(1),
    t(", "),
    i(2),
    t(" in zip("),
    i(3),
    t(", "),
    i(4),
    t({ "):", "\t" }),
    i(5),
  }),
  s({
    trig = "for .. zip", -- Inline version
    show_condition = -(conds.line_begin + conds.make_prefix_condition("async ")) * is_in_code_condition,
    desc = [[`for .. in zip(..)`]],
  }, {
    t("for "),
    i(1),
    t(", "),
    i(2),
    t(" in zip("),
    i(3),
    t(", "),
    i(4),
    t(")"),
  }),

  s({
    trig = "from .. import",
    show_condition = conds.line_begin * ls_show_conds.line_end * is_in_code_condition,
    desc = [[`from .. import ..`]],
  }, {
    t("from "),
    i(1),
    t(" import "),
    i(2),
  }),
  s({
    trig = "from .. import .. as",
    show_condition = conds.line_begin * ls_show_conds.line_end * is_in_code_condition,
    desc = [[`from .. import .. as`]],
  }, {
    t("from "),
    i(1),
    t(" import "),
    i(2),
    t(" as "),
    i(3),
  }),

  s({
    trig = "if .. else", -- Inline version
    show_condition = -conds.line_begin * is_in_code_condition,
    desc = [[`if .. else ..`]],
  }, {
    t("if "),
    i(1),
    t(" else "),
    i(2),
  }),

  s({
    trig = "import",
    show_condition = conds.line_begin * ls_show_conds.line_end * is_in_code_condition,
    desc = [[`import ..`]],
  }, {
    t("import "),
    i(1),
  }),
  s({
    trig = "import .. as",
    show_condition = conds.line_begin * ls_show_conds.line_end * is_in_code_condition,
    desc = [[`import .. as ..`]],
  }, {
    t("import "),
    i(1),
    t(" as "),
    i(2),
  }),

  s({
    trig = "main",
    show_condition = conds.line_begin * ls_show_conds.line_end * conds.make_treesitter_node_inclusion_condition({
      "module",
    }),
    desc = [[`if __name__ == "__main__": <../pass>`]],
  }, {
    t({ 'if __name__ == "__main__":', "\t" }),
    i(1),
  }),
}
