local ls = require("luasnip")
local ls_conds = require("luasnip.extras.conditions")
local snippet_conds = require("config.snippets.conditions")

local c = ls.choice_node
local f = ls.function_node
local i = ls.insert_node
local r = ls.restore_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local local_conds = {}
local snippets = {}

-- [[ Todo-comment snippets ]]
-- Initially taken from: https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets#all---todo-commentsnvim-snippets

---@return string[]|nil
local function get_comment_string_parts()
  if vim.bo.commentstring == "" then
    return nil
  end
  -- Comment strings are used with `format` with a `%s` placeholder
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

---@return string|nil
local function get_comment_string_start()
  local comment_string_parts = get_comment_string_parts()
  if not comment_string_parts then
    return nil
  end
  return comment_string_parts[1]
end

---@return string|nil
local function get_comment_string_end()
  local comment_string_parts = get_comment_string_parts()
  if not comment_string_parts then
    return nil
  end
  return comment_string_parts[2]
end

local todo_keywords = { "_TODO", "TODO", "FIXME", "BUG" }
local note_keywords = { "NOTE", "HACK", "WARN" }

local excluded_filetypes = {
  "gitcommit",
  "markdown", -- Todo-comments are not recognized by todo-comments.nvim anyway
}

local function get_description(keywords)
  local keywords_description = [[
Supported keywords:]]
  for _, keyword in ipairs(keywords) do
    keywords_description = keywords_description .. "\n- `" .. keyword .. "`"
  end
  return keywords_description
end
local todo_description = get_description(todo_keywords)
local note_description = get_description(note_keywords)

local function get_snippet_choices(keywords)
  local snippet_choices = {}
  for _, keyword in ipairs(keywords) do
    table.insert(snippet_choices, sn(nil, { t(keyword .. ": "), r(1, "content", i(nil)) }))
  end
  return snippet_choices
end

local_conds.support_todo_comments = ls_conds.make_condition(function()
  local is_special_buffer = vim.bo.buftype ~= ""
  if is_special_buffer then
    return false
  end
  local is_filetype_excluded = vim.tbl_contains(excluded_filetypes, vim.bo.filetype)
  if is_filetype_excluded then
    return false
  end
  local is_commenstring_set = vim.bo.commentstring ~= ""
  if not is_commenstring_set then
    return false
  end
  local is_treesitter_available, _ = pcall(vim.treesitter.get_parser)
  if not is_treesitter_available then
    return true
  end
  return true
end)

local todo_comment_snippets = {
  s({
    trig = "todo-comment",
    show_condition = snippet_conds.line_end * local_conds.support_todo_comments * snippet_conds.code,
    desc = todo_description,
  }, {
    f(get_comment_string_start),
    c(1, get_snippet_choices(todo_keywords)),
    f(get_comment_string_end),
  }),
  s({
    trig = "note-comment",
    show_condition = snippet_conds.line_end * local_conds.support_todo_comments * snippet_conds.code,
    desc = note_description,
  }, {
    f(get_comment_string_start),
    c(1, get_snippet_choices(note_keywords)),
    f(get_comment_string_end),
  }),
  s({
    trig = "todo-keyword",
    show_condition = snippet_conds.line_end * local_conds.support_todo_comments * snippet_conds.comment,
    desc = todo_description,
  }, {
    c(1, get_snippet_choices(todo_keywords)),
  }),
  s({
    trig = "note-keyword",
    show_condition = snippet_conds.line_end * local_conds.support_todo_comments * snippet_conds.comment,
    desc = note_description,
  }, {
    c(1, get_snippet_choices(note_keywords)),
  }),
}
snippets = vim.list_extend(snippets, todo_comment_snippets)

return snippets
