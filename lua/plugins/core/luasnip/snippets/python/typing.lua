-- Snippets for Python builtin type hints. These corresponds to builtin Python classes (like `list`)
-- but with additional square brackets. Classes from the standard library (like `typing.List`) are
-- not implemented because the completion provided by the language server also comes with a cool
-- auto-importation.

local ls = require("luasnip")

local custom_conds = require("plugins.core.luasnip.conditions")

local c = ls.choice_node
local i = ls.insert_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local is_in_code_inline = custom_conds.ts.is_in_code * -custom_conds.ts.line_begin

return {
  s({ trig = "list[..]", show_condition = is_in_code_inline }, {
    t("list["),
    c(1, { i(nil), t("str"), t("bool"), t("float"), t("int") }),
    t("]"),
    c(2, { i(nil), sn(nil, { t(" | "), i(1) }), t(" | None") }),
  }),
  s({ trig = "set[..]", show_condition = is_in_code_inline }, {
    t("set["),
    c(1, { i(nil), t("str"), t("bool"), t("float"), t("int") }),
    t("]"),
    c(2, { i(nil), sn(nil, { t(" | "), i(1) }), t(" | None") }),
  }),
  s({ trig = "tuple[..]", show_condition = is_in_code_inline }, {
    t("tuple["),
    c(1, { i(nil), t("str"), t("bool"), t("float"), t("int") }),
    t(", "),
    c(2, { i(nil), t("..."), t("str"), t("bool"), t("float"), t("int") }),
    t("]"),
    c(3, { i(nil), sn(nil, { t(" | "), i(1) }), t(" | None") }),
  }),
  s({ trig = "dict[..]", show_condition = is_in_code_inline }, {
    t("dict["),
    c(1, { i(nil), t("str"), t("bool"), t("float"), t("int") }),
    t(", "),
    c(2, { i(nil), t("str"), t("bool"), t("float"), t("int") }),
    t("]"),
    c(3, { i(nil), sn(nil, { t(" | "), i(1) }), t(" | None") }),
  }),
}
