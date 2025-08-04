-- These snippets are built to be used alongside the lua-ls language server, which also defines snippets

local conds = require("config.snippets.conditions")
local ls = require("luasnip")

local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

local local_conds = {}

local_conds.is_in_code = conds.make_ts_node_not_in_condition({
  "comment",
  "comment_content",
  "string",
  "string_content",
  "table_constructor",
})

return {
  -- lua-ls already provides a `local function` snippet
  s({
    trig = "local",
    show_condition = local_conds.is_in_code,
    desc = [[`local … = …`]],
  }, {
    t("local "),
    i(1),
    t(" = "),
    i(2),
  }),
  s({
    trig = "local … require",
    show_condition = local_conds.is_in_code,
    desc = [[`local … = require("…")`]],
  }, {
    t("local "),
    i(1),
    t(' = require("'),
    i(2),
    t('")'),
  }),
}
