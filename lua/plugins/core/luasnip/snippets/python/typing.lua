-- Snippets for Python builtin type hints. These corresponds to builtin Python classes (like `list`)
-- but with additional square brackets. Classes from the standard library (like `typing.List`) are
-- not implemented because the completion provided by the language server also comes with a cool
-- auto-importation.

local extras = require("luasnip.extras")
local ls = require("luasnip")

local custom_conds = require("plugins.core.luasnip.conditions")

local c = ls.choice_node
local i = ls.insert_node
local rep = extras.rep
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local is_in_code_inline = custom_conds.ts.is_in_code * -custom_conds.line_begin

return {

  -- [[ Builtins ]]

  s({ trig = "list[..]", show_condition = is_in_code_inline }, {
    t("list["),
    c(1, { i(nil), t("str"), t("bool"), t("float"), t("int") }),
    t("]"),
  }),
  s({ trig = "set[..]", show_condition = is_in_code_inline }, {
    t("set["),
    c(1, { i(nil), t("str"), t("bool"), t("float"), t("int") }),
    t("]"),
  }),
  s({ trig = "tuple[..]", show_condition = is_in_code_inline }, {
    c(1, {
      sn(nil, { t("tuple["), i(1), t(", "), i(2), t("]") }),
      sn(nil, { t("tuple["), i(1), t(", "), t("..."), t("]") }),
      sn(nil, { t("tuple["), i(1), t(", "), rep(1), t("]") }),
      sn(nil, { t("tuple["), i(1), t(", "), rep(1), t(", "), rep(1), t("]") }),
      sn(nil, { t("tuple["), i(1), t(", "), rep(1), t(", "), rep(1), t(", "), rep(1), t("]") }),
    }),
  }),
  s({ trig = "dict[..]", show_condition = is_in_code_inline }, {
    t("dict["),
    c(1, { i(nil), t("str"), t("bool"), t("float"), t("int") }),
    t(", "),
    c(2, { i(nil), t("str"), t("bool"), t("float"), t("int") }),
    t("]"),
  }),

  -- [[ Typing inspired ]]

  -- Inspired by `typing.Optional` but with no import required
  -- Works both before typing the other type (like `typing.Optional`) or after (like `| None`)
  s({ trig = "optional", show_condition = is_in_code_inline }, {
    i(1),
    t(" | None"),
  }),
}
