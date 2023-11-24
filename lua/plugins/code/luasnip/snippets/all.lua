local ls = require("luasnip")

local c = ls.choice_node
local f = ls.function_node
local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

local fmt = require("luasnip.extras.fmt").fmt

local custom_conds = require("plugins.code.luasnip.custom.conds")

local utils = require("plugins.code.luasnip.custom.utils")

return {
  -- [[ Todo-comments]]
  -- Let's define two auto-snippets, one for when in comments and one for when in code.
  s(
    {
      trig = "td ",
      snippetType = "autosnippet",
      condition = custom_conds.is_in_comment,
    },
    fmt(
      [[
        {}: {}
      ]],
      {
        c(2, { t("TODO"), t("NOTE"), t("BUG"), t("FIXME"), t("ISSUE") }),
        i(1),
      }
    )
  ),
  -- Snippet below is adapted from
  -- https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets#all---todo-commentsnvim-snippets
  s(
    {
      trig = "td ",
      snippetType = "autosnippet",
      condition = custom_conds.is_in_code,
    },
    fmt(
      [[
        {} {}: {} {}
      ]],
      {
        f(function()
          return utils.get_comment_strings(1)[1]
        end),
        c(2, { t("TODO"), t("NOTE"), t("BUG"), t("FIXME"), t("ISSUE") }),
        i(1),
        f(function()
          return utils.get_comment_strings(1)[2]
        end),
      }
    )
  ),
}
