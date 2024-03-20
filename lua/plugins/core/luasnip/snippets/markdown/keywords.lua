local ls = require("luasnip")
local show_conds = require("luasnip.extras.conditions.show")

local custom_conds = require("plugins.core.luasnip.conditions")

local c = ls.choice_node
local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

return {
  s("link", { t("["), i(1, "name"), t("]("), i(2, "url"), t(")") }),
  s({ trig = "code-block", show_condition = custom_conds.line_begin * show_conds.line_end }, {
    t("```"),
    c(1, { i(nil), t("shell"), t("python") }),
    t({ "", "" }),
    i(2),
    t({ "", "```" }),
  }),
  s({ trig = "toggle-block", show_condition = custom_conds.line_begin * show_conds.line_end }, {
    t({ "<details>", "<summary>" }),
    i(1, "Summary"),
    -- Line break after the summary is important for some blocks like code-blocks
    t({ "</summary>", "", "" }),
    i(2, "Content"),
    t({ "", "", "</details>" }),
  }),
}
