local ls = require("luasnip")

local c = ls.choice_node
local f = ls.function_node
local i = ls.insert_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local custom_show_conds = require("plugins.core.luasnip.show_conds")

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

  if left ~= "" then
    left = left .. " "
  end
  if right ~= "" then
    right = " " .. right
  end

  return { left, right }
end

local function get_comment_string_start()
  return get_comment_strings(1)[1]
end
local function get_comment_string_end()
  return get_comment_strings(1)[2]
end

return {
  s({
    trig = "todo-comment", -- In-code version
    show_condition = custom_show_conds.is_in_code * -custom_show_conds.is_in_string,
  }, {
    -- Adapted from
    -- https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets#all---todo-commentsnvim-snippets
    f(get_comment_string_start),
    c(1, { -- Snippet nodes below are weirdly defined to avoid being recognized as a todo-comment
      sn(nil, { t("TODO"), t(": "), i(1) }),
      sn(nil, { t("NOTE"), t(": "), i(1) }),
      sn(nil, { t("BUG"), t(": "), i(1) }),
      sn(nil, { t("FIXME"), t(": "), i(1) }),
      sn(nil, { t("ISSUE"), t(": "), i(1) }),
    }),
    f(get_comment_string_end),
  }),
  s({
    trig = "todo-comment", -- In-comment version (don't add comment strings)
    show_condition = custom_show_conds.is_in_comment * -custom_show_conds.is_in_string,
  }, {
    c(1, { -- Snippet nodes below are weirdly defined to avoid being recognized as a todo-comment
      sn(nil, { t("TODO"), t(": "), i(1) }),
      sn(nil, { t("NOTE"), t(": "), i(1) }),
      sn(nil, { t("BUG"), t(": "), i(1) }),
      sn(nil, { t("FIXME"), t(": "), i(1) }),
      sn(nil, { t("ISSUE"), t(": "), i(1) }),
    }),
  }),
}
