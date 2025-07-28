local conds = require("config.snippets.conditions")
local ls = require("luasnip")
local ls_conds = require("luasnip.extras.conditions")

local c = ls.choice_node
local f = ls.function_node
local i = ls.insert_node
local r = ls.restore_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

-- [[ Todo-comment snippets ]]
-- Initial source: https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets#all---todo-commentsnvim-snippets.
-- The first implementation was then modified to avoid relying on the `Comment.nvim` plugin

--- Get the comment string start and end, taking the current file type into account.
---@return string[]
local function get_comment_strings()
  -- Initially, comment strings are ready to be used by `format`, so we want to split the left and right side. This
  -- implementation is taken from `require("Comment.nvim.utils").unwrap_cstr`.
  local left, right = string.match(vim.bo.commentstring, "(.*)%%s(.*)")
  assert(
    (left or right),
    { msg = string.format("Invalid commentstring for %s! Read `:h commentstring` for help.", vim.bo.filetype) }
  )
  left, right = vim.trim(left), vim.trim(right)
  if left ~= "" then
    left = left .. " "
  end
  if right ~= "" then
    right = " " .. right
  end
  return { left, right }
end
local function get_comment_string_start() return get_comment_strings()[1] end
local function get_comment_string_end() return get_comment_strings()[2] end

-- Let's only support a useful subset of todo-comment keywords, instead of all the recognized keywords
local todo_keywords = {
  "_TODO",
  "TODO",
  "FIXME",
  "BUG",
  "HACK",
  "WARN",
  "PERF",
  "TEST",
  "NOTE",
}

local todo_keywords_description = [[
Supported keywords:]]
for _, todo_keyword in ipairs(todo_keywords) do
  todo_keywords_description = todo_keywords_description .. "\n- `" .. todo_keyword .. "`"
end

local function get_todo_keyword_snippet_choices()
  local todo_keyword_snippet_choices = {}
  for _, todo_keyword in ipairs(todo_keywords) do
    table.insert(todo_keyword_snippet_choices, sn(nil, { t(todo_keyword .. ": "), r(1, "content", i(nil)) }))
  end
  return todo_keyword_snippet_choices
end

local todo_comment_show_condition = ls_conds.make_condition(function(line_to_cursor)
  local is_treesitter_available, _ = pcall(vim.treesitter.get_parser)
  if not is_treesitter_available then
    return true
  end
  local is_treesitter_parsable, node = pcall(conds.get_treesitter_node, line_to_cursor)
  if not is_treesitter_parsable then
    return false
  end
  if not node then -- E.g. very beginning of the buffer
    return true
  end
  return not vim.tbl_contains({
    "comment",
    "comment_content",
    "html_block", -- Markdown comments
    "line_comment",
    "string",
    "string_start",
    "string_content",
  }, node:type())
end)

local todo_keyword_show_condition = ls_conds.make_condition(function(line_to_cursor)
  local is_treesitter_available, _ = pcall(vim.treesitter.get_parser)
  if not is_treesitter_available then
    return false
  end
  local is_treesitter_parsable, node = pcall(conds.get_treesitter_node, line_to_cursor)
  if not is_treesitter_parsable then
    return false
  end
  if not node then -- E.g. very beginning of the buffer
    return false
  end
  return vim.tbl_contains({
    "comment",
    "comment_content",
    "html_block", -- Markdown comments
    "line_comment",
  }, node:type())
end)

local M = {
  s({
    trig = "todo-comment",
    show_condition = todo_comment_show_condition,
    desc = todo_keywords_description,
  }, {
    f(get_comment_string_start),
    c(1, get_todo_keyword_snippet_choices()),
    f(get_comment_string_end),
  }),
  s({
    trig = "todo-keyword",
    show_condition = todo_keyword_show_condition,
    desc = todo_keywords_description,
  }, {
    c(1, get_todo_keyword_snippet_choices()),
  }),
}
for _, todo_keyword in ipairs(todo_keywords) do
  table.insert(
    M,
    s({
      trig = todo_keyword .. ": ",
      show_condition = todo_keyword_show_condition,
      desc = "`" .. todo_keyword .. ": …`",
    }, {
      t(todo_keyword .. ": "),
      i(1),
    })
  )
end

return M
