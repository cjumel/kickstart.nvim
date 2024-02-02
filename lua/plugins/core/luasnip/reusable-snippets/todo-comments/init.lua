-- Provide todo-comment snippets for files **not** supporting treesitter.

local ls = require("luasnip")

local tdc_snippet_utils = require("plugins.core.luasnip.reusable-snippets.todo-comments.utils")

local c = ls.choice_node
local f = ls.function_node
local s = ls.snippet

return {
  s({
    trig = "todo-comment",
  }, {
    -- Adapted from
    -- https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets#all---todo-commentsnvim-snippets
    f(tdc_snippet_utils.get_comment_string_start),
    c(1, tdc_snippet_utils.get_tdc_sn_options()),
    f(tdc_snippet_utils.get_comment_string_end),
  }),
}
