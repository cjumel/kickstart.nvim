local ls = require("luasnip")

local c = ls.choice_node
local f = ls.function_node
local i = ls.insert_node
local s = ls.snippet

local fmt = require("luasnip.extras.fmt").fmt

local custom_conds = require("plugins.code.luasnip.utils.conds")

local calculate_comment_string = require("Comment.ft").calculate
local utils = require("Comment.utils")

--- Get the comment string { start, end } table. Function is taken from
--- https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets#all---todo-commentsnvim-snippets.
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

local function get_comment_string_start()
  return get_comment_strings(1)[1]
end
local function get_comment_string_end()
  return get_comment_strings(1)[2]
end

return {
  s(
    {
      trig = "td ", -- In-comment version (don't add comment strings)
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
  s(
    {
      trig = "td ", -- In-code version (add comment strings)
      snippetType = "autosnippet",
      condition = custom_conds.is_in_code,
    },
    c(1, {
      -- Adapted from
      -- https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets#all---todo-commentsnvim-snippets
      fmt("{} TODO: {}{}", { f(get_comment_string_start), i(1), f(get_comment_string_end) }),
      fmt("{} NOTE: {}{}", { f(get_comment_string_start), i(1), f(get_comment_string_end) }),
      fmt("{} BUG: {}{}", { f(get_comment_string_start), i(1), f(get_comment_string_end) }),
      fmt("{} FIXME: {}{}", { f(get_comment_string_start), i(1), f(get_comment_string_end) }),
      fmt("{} ISSUE: {}{}", { f(get_comment_string_start), i(1), f(get_comment_string_end) }),
    })
  ),
}
