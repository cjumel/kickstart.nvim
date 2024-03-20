-- Snippets for Lua keywords involving multiple words (simple one-word keyword completion is
-- directly handled by the LSP)
-- Many snippets here are inspired by the keyword snippets of lua_ls

local ls = require("luasnip")

local custom_conds = require("plugins.core.luasnip.conditions")
local show_conds = require("luasnip.extras.conditions.show")

local c = ls.choice_node
local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

local is_in_code = custom_conds.ts.is_in_code
local is_in_code_empty_line = custom_conds.ts.is_in_code
  * custom_conds.line_begin
  * show_conds.line_end

local todo = "-- TO" .. "DO: implement" -- not recognized by todo-comments

return {

  -- Local
  s({ trig = "local .. = ..", show_condition = is_in_code_empty_line }, {
    t("local "),
    i(1),
    t(" = "),
    c(2, { i(2), t("{}"), t("nil"), t("false"), t("true") }),
  }),

  -- Function
  s({ trig = "function ()", show_condition = is_in_code }, {
    t("function "),
    i(1),
    t("("),
    i(2),
    t({ ")", "\t" }),
    c(3, { i(1), t(todo) }),
    t({ "", "end" }),
  }),

  -- Conditions
  s({ trig = "if .. then", show_condition = is_in_code_empty_line }, {
    t("if "),
    i(1),
    t({ " then", "\t" }),
    c(2, { i(1), t(todo) }),
    t({ "", "end" }),
  }),
  s({ trig = "elsif .. then", show_condition = is_in_code_empty_line }, {
    t("elseif "),
    i(1),
    t({ " then", "\t" }),
    c(2, { i(1), t(todo) }),
  }),
  s({ trig = "else", show_condition = is_in_code_empty_line }, {
    t({ "else", "\t" }),
    c(1, { i(1), t(todo) }),
  }),

  -- For
  s({ trig = "for .. do", show_condition = is_in_code_empty_line }, {
    t("for "),
    i(1),
    t({ " do", "\t" }),
    c(2, { i(1), t(todo) }),
    t({ "", "end" }),
  }),
  s({ trig = "for .. pairs ..", show_condition = is_in_code_empty_line }, {
    t("for "),
    i(1, "k"),
    t(", "),
    i(2, "v"),
    t(" in pairs("),
    i(3, "t"),
    t({ ") do", "\t" }),
    c(4, { i(1), t(todo) }),
    t({ "", "end" }),
  }),
  s({ trig = "for .. ipairs ..", show_condition = is_in_code_empty_line }, {
    t("for "),
    c(1, { i(1, "i"), t("_") }),
    t(", "),
    i(2, "x"),
    t(" in ipairs("),
    i(3, "t"),
    t({ ") do", "\t" }),
    c(4, { i(1), t(todo) }),
    t({ "", "end" }),
  }),

  -- While
  s({ trig = "while .. do", show_condition = is_in_code_empty_line }, {
    t("while "),
    i(1),
    t({ " do", "\t" }),
    c(2, { i(1), t(todo) }),
    t({ "", "end" }),
  }),
}
