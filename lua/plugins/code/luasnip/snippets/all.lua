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
    c(1, {
      fmt("TODO: {}", { i(1) }),
      fmt("NOTE: {}", { i(1) }),
      fmt("BUG: {}", { i(1) }),
      fmt("FIXME: {}", { i(1) }),
      fmt("ISSUE: {}", { i(1) }),
    })
  ),
  -- Snippet below is adapted from
  -- https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets#all---todo-commentsnvim-snippets
  s(
    {
      trig = "td ",
      snippetType = "autosnippet",
      condition = custom_conds.is_in_code,
    },
    c(1, {
      fmt("{} TODO: {}{}", {
        f(function()
          return utils.get_comment_strings(1)[1]
        end),
        i(1),
        f(function()
          return utils.get_comment_strings(1)[2]
        end),
      }),
      fmt("{} NOTE: {}{}", {
        f(function()
          return utils.get_comment_strings(1)[1]
        end),
        i(1),
        f(function()
          return utils.get_comment_strings(1)[2]
        end),
      }),
      fmt("{} BUG: {}{}", {
        f(function()
          return utils.get_comment_strings(1)[1]
        end),
        i(1),
        f(function()
          return utils.get_comment_strings(1)[2]
        end),
      }),
      fmt("{} FIXME: {}{}", {
        f(function()
          return utils.get_comment_strings(1)[1]
        end),
        i(1),
        f(function()
          return utils.get_comment_strings(1)[2]
        end),
      }),
      fmt("{} ISSUE: {}{}", {
        f(function()
          return utils.get_comment_strings(1)[1]
        end),
        i(1),
        f(function()
          return utils.get_comment_strings(1)[2]
        end),
      }),
    })
  ),
}
