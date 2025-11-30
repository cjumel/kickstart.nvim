-- These snippets are designed to be used alongside the rust-analyzer language server, which also implements snippets

local ls = require("luasnip")
local snippet_conds = require("config.snippets.conditions")

local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

return {
  s( -- `fn` with return type (`fn` snippet is implemented by rust-analyzer)
    { trig = "fnr", show_condition = snippet_conds.empty_line },
    { t("fn "), i(1), t("("), i(2), t(") -> "), i(3), t({ " {", "\t" }), i(4), t({ "", "}" }) }
  ),
  s({ trig = "let", show_condition = snippet_conds.empty_line }, { t("let "), i(1), t(" = "), i(2), t(";") }),
  s({ trig = "let mut", show_condition = snippet_conds.empty_line }, { t("let mut "), i(1), t(" = "), i(2), t(";") }),
}
