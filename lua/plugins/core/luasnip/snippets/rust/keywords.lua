-- These snippets are built to be used alongside the rust-analyzer language server, which also defines snippets

local conds = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")
local ls_show_conds = require("luasnip.extras.conditions.show")

local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

return {
  -- Rust-analyzer already provides a `fn` snippet for function definition without return type
  s({
    trig = "fnr", -- `fn` with return type
    desc = [[`fn …(…) -> … { … }`]],
  }, {
    t("fn "),
    i(1),
    t("("),
    i(2),
    t(") -> "),
    i(3),
    t({ " {", "\t" }),
    i(4),
    t({ "", "}" }),
  }),

  s({
    trig = "let",
    show_condition = conds.line_begin * ls_show_conds.line_end,
    desc = [[`let … = …;]],
  }, {
    t("let "),
    i(1),
    t(" = "),
    i(2),
    t(";"),
  }),
  s({
    trig = "let mut",
    show_condition = conds.line_begin * ls_show_conds.line_end,
    desc = [[`let mut … = …;]],
  }, {
    t("let mut "),
    i(1),
    t(" = "),
    i(2),
    t(";"),
  }),
}
