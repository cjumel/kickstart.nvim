local conds = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")
local ls_show_conds = require("luasnip.extras.conditions.show")

local c = ls.choice_node
local i = ls.insert_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

return {

  s({
    trig = "noqa",
    show_condition = conds.make_treesitter_node_inclusion_condition({ "comment" })
      * conds.is_comment_start
      * ls_show_conds.line_end,
    desc = [[
Ignore lint warnings (e.g. for Flake8 or Ruff).
Choices:
- `noqa`
- `noqa: ..`]],
  }, {
    c(1, {
      sn(nil, { t("noqa"), i(1) }),
      sn(nil, { t("noqa: "), i(1) }),
    }),
  }),

  s({
    trig = "pragma: no cover",
    show_condition = conds.make_treesitter_node_inclusion_condition({ "comment" })
      * conds.is_comment_start
      * ls_show_conds.line_end,
    desc = [[
Exclude from coverage reports (e.g. for coverage.py or pytest-cov).
`pragma: no cover`]],
  }, { t("pragma: no cover"), i(1) }),

  s({
    trig = "ruff: noqa",
    show_condition = conds.make_treesitter_node_inclusion_condition({ "comment" })
      * conds.is_comment_start
      * ls_show_conds.line_end
      * conds.first_line,
    desc = [[
Ignore ruff warnings for the entire file.
Choices:
- `ruff: noqa`
- `ruff: noqa: ..`]],
  }, {
    c(1, {
      sn(nil, { t("ruff: noqa"), i(1) }),
      sn(nil, { t("ruff: noqa: "), i(1) }),
    }),
  }),

  s({
    trig = "type: ignore",
    show_condition = conds.make_treesitter_node_inclusion_condition({ "comment" })
      * conds.is_comment_start
      * ls_show_conds.line_end,
    desc = [[
Ignore typing warnings (e.g. for mypy or Pyright).
Choices:
- `type: ignore`
- `type: ignore[..]`]],
  }, {
    c(1, {
      sn(nil, { t("type: ignore"), i(1) }),
      sn(nil, { t("type: ignore["), i(1), t("]") }),
    }),
  }),
}
