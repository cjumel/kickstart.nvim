-- Snippets for Python builtin type hints. These corresponds to builtin Python classes (like `list`)
-- but with additional square brackets. Classes from the standard library (like `typing.List`) are
-- not implemented because the completion provided by the language server also comes with a cool
-- auto-importation.

local ls = require("luasnip")

local custom_conds = require("plugins.core.luasnip.conditions")

local c = ls.choice_node
local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

local is_in_code_inline = custom_conds.ts.is_in_code * -custom_conds.ts.line_begin

return {
  s({ trig = "list[..]", show_condition = is_in_code_inline }, {
    t("list["),
    i(1),
    t("]"),
  }),
  s({ trig = "set[..]", show_condition = is_in_code_inline }, {
    t("set["),
    i(1),
    t("]"),
  }),
  s({ trig = "tuple[..]", show_condition = is_in_code_inline }, {
    t("tuple["),
    i(1),
    t(", "),
    c(2, { i(1), t("...") }),
    t("]"),
  }),
  s({ trig = "dict[..]", show_condition = is_in_code_inline }, {
    t("dict["),
    i(1),
    t(", "),
    i(2),
    t("]"),
  }),
}
