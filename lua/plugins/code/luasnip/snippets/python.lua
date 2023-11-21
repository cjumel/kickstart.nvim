local ls = require("luasnip")

local c = ls.choice_node
local s = ls.snippet
local t = ls.text_node

return {
  s("todo-comment", {
    t("# "),
    c(1, {
      t("TODO: "),
      t("NOTE: "),
      t("BUG: "),
      t("FIXME: "),
      t("ISSUE: "),
    }),
  }),
}
