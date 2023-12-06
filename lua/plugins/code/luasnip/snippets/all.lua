local ls = require("luasnip")

local c = ls.choice_node
local f = ls.function_node
local i = ls.insert_node
local s = ls.snippet

local fmt = require("luasnip.extras.fmt").fmt

local custom_conds = require("plugins.code.luasnip.utils.conds")

local calculate_comment_string = require("Comment.ft").calculate
local utils = require("Comment.utils")

-- Function below is taken from
-- https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets#all---todo-commentsnvim-snippets

--- Get the comment string { beg, end } table
---@param ctype integer 1 for `line`-comment and 2 for `block`-comment
---@return table comment_strings {begcstring, endcstring}
local get_comment_strings = function(ctype)
  -- use the `Comments.nvim` API to fetch the comment string for the region
  -- (eq. '--%s' or '--[[%s]]' for `lua`)
  local cstring = calculate_comment_string({ ctype = ctype, range = utils.get_region() })
    or vim.bo.commentstring
  -- as we want only the strings themselves and not strings ready for using `format` we want to
  -- split the left and right side
  local left, right = utils.unwrap_cstr(cstring)
  -- create a `{left, right}` table for it
  return { left, right }
end

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
          return get_comment_strings(1)[1]
        end),
        i(1),
        f(function()
          return get_comment_strings(1)[2]
        end),
      }),
      fmt("{} NOTE: {}{}", {
        f(function()
          return get_comment_strings(1)[1]
        end),
        i(1),
        f(function()
          return get_comment_strings(1)[2]
        end),
      }),
      fmt("{} BUG: {}{}", {
        f(function()
          return get_comment_strings(1)[1]
        end),
        i(1),
        f(function()
          return get_comment_strings(1)[2]
        end),
      }),
      fmt("{} FIXME: {}{}", {
        f(function()
          return get_comment_strings(1)[1]
        end),
        i(1),
        f(function()
          return get_comment_strings(1)[2]
        end),
      }),
      fmt("{} ISSUE: {}{}", {
        f(function()
          return get_comment_strings(1)[1]
        end),
        i(1),
        f(function()
          return get_comment_strings(1)[2]
        end),
      }),
    })
  ),
}
