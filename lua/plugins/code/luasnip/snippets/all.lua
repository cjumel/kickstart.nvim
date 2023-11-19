local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

return {
  s("fixme", {
    t("FIXME: "),
  }),
  s("todo", {
    t("TODO: "),
  }),
  s("hack", {
    t("HACK: "),
  }),
  s("warn", {
    t("WARN: "),
  }),
  s("perf", {
    t("PERF: "),
  }),
  s("note", {
    t("NOTE: "),
  }),
  s("test", {
    t("TEST: "),
  }),
}
