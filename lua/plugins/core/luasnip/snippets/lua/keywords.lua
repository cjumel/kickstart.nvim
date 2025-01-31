-- These snippets are built to be used alongside the lua-ls language server, which also defines snippets

local conds = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")

local c = ls.choice_node
local i = ls.insert_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

-- Condition to avoid triggering a snippet inside a string or a comment
local is_in_code_condition = conds.make_treesitter_node_exclusion_condition({
  "comment",
  "comment_content",
  "string",
  "string_content",
  "table_constructor",
})

return {
  -- lua-ls provides a `local function` snippet
  s({
    trig = "local .. = ..",
    show_condition = is_in_code_condition,
    desc = [[`local .. = <../require("..")>`]],
  }, {
    t("local "),
    i(1),
    t(" = "),
    c(2, { i(1), sn(nil, { t('require("'), i(1), t('")') }) }),
  }),
}
