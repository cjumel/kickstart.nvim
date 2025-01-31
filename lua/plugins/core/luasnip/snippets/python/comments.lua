local conds = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")
local ls_show_conds = require("luasnip.extras.conditions.show")

local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

local is_in_comment_condition = conds.make_treesitter_node_inclusion_condition({ "comment" })

return {
  s({
    trig = "noqa",
    show_condition = is_in_comment_condition * conds.is_comment_start * ls_show_conds.line_end,
    desc = [[`noqa` (ignore lint warnings, e.g. for Flake8 or Ruff; can specify rules with `:`)]],
  }, {
    t("noqa"),
    i(1),
  }),

  s({
    trig = "pragma: no cover",
    show_condition = is_in_comment_condition * conds.is_comment_start * ls_show_conds.line_end,
    desc = [[`pragma: no cover` (exclude from coverage reports, e.g. for coverage.py or pytest-cov)]],
  }, {
    t("pragma: no cover"),
    i(1),
  }),

  s({
    trig = "ruff: noqa",
    show_condition = is_in_comment_condition * conds.is_comment_start * ls_show_conds.line_end * conds.first_line,
    desc = [[`ruff: noqa` (ignore ruff warnings for the entire file; can specify rules with `:`)]],
  }, {
    t("ruff: noqa"),
    i(1),
  }),

  s({
    trig = "type: ignore",
    show_condition = is_in_comment_condition * conds.is_comment_start * ls_show_conds.line_end,
    desc = [[`type: ignore` (ignore typing warnings, e.g. for mypy or Pyright; can specify rules with `[]`)]],
  }, {
    t("type: ignore"),
    i(1),
  }),
}
