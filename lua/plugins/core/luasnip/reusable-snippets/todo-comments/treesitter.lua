-- Provide todo-comment snippets for files supporting treesitter. These snippets provide extra
-- features like not adding comment strings when already in comment.

local ls = require("luasnip")

local custom_show_conds = require("plugins.core.luasnip.show_conds")
local tdc_snippet_utils = require("plugins.core.luasnip.reusable-snippets.todo-comments.utils")

local c = ls.choice_node
local f = ls.function_node
local s = ls.snippet

return {
  s({
    trig = "todo-comment", -- In-code version
    show_condition = custom_show_conds.ts.is_in_code,
  }, {
    -- Adapted from
    -- https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets#all---todo-commentsnvim-snippets
    f(tdc_snippet_utils.get_comment_string_start),
    c(1, tdc_snippet_utils.get_tdc_sn_options()),
    f(tdc_snippet_utils.get_comment_string_end),
  }),
  s({
    trig = "todo-comment", -- In-comment version (don't add comment strings)
    show_condition = custom_show_conds.ts.is_in_comment,
  }, {
    c(1, tdc_snippet_utils.get_tdc_sn_options()),
  }),
}
