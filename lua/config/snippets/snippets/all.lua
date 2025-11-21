-- TODO: show_condition calls have been commented out since they don't work well currently with blink.cmp

local conds = require("config.snippets.conditions")
local ls = require("luasnip")
local ls_conds = require("luasnip.extras.conditions")
local utils = require("config.snippets.utils")

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

---@return string[]|nil
local function get_comment_string_parts()
  if vim.bo.commentstring == "" then
    return nil
  end
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

local excluded_filetypes = {
  "gitcommit",
  "markdown", -- Todo-comments are not recognized by todo-comments.nvim
}

local function _get_todo_keyword_descriptions(keywords)
  local keywords_description = [[
Supported keywords:]]
  for _, todo_keyword in ipairs(keywords) do
    keywords_description = keywords_description .. "\n- `" .. todo_keyword .. "`"
  end
  return keywords_description
end
local function get_todo_keywords_description()
  return _get_todo_keyword_descriptions({ "_TODO", "TODO", "FIXME", "BUG" })
end
local function get_note_keywords_description() return _get_todo_keyword_descriptions({ "NOTE", "HACK", "WARN" }) end

local function _get_todo_keyword_snippet_choices(keywords)
  local todo_keyword_snippet_choices = {}
  for _, todo_keyword in ipairs(keywords) do
    table.insert(todo_keyword_snippet_choices, sn(nil, { t(todo_keyword .. ": "), r(1, "content", i(nil)) }))
  end
  return todo_keyword_snippet_choices
end
local function get_todo_keyword_snippet_choices()
  return _get_todo_keyword_snippet_choices({ "_TODO", "TODO", "FIXME", "BUG" })
end
local function get_note_keyword_snippet_choices() return _get_todo_keyword_snippet_choices({ "NOTE", "HACK", "WARN" }) end

local todo_comment_show_condition = conds.line_end
  * ls_conds.make_condition(function(line_to_cursor)
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
    local is_treesitter_parsable, node = pcall(utils.get_treesitter_node_at_trigger, line_to_cursor)
    if not is_treesitter_parsable then
      return false
    end
    if not node then -- E.g. very beginning of the buffer
      return true
    end
    local is_in_code = not vim.tbl_contains({
      "comment",
      "comment_content",
      "line_comment",
      "string",
      "string_start",
      "string_content",
    }, node:type())
    return is_in_code
  end)

local todo_keyword_show_condition = ls_conds.make_condition(function(line_to_cursor)
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
    return false
  end
  local is_treesitter_parsable, node = pcall(utils.get_treesitter_node_at_trigger, line_to_cursor)
  if not is_treesitter_parsable then
    return false
  end
  if not node then -- E.g. very beginning of the buffer
    return false
  end
  local is_in_comment = vim.tbl_contains({
    "comment",
    "comment_content",
    "line_comment",
  }, node:type())
  return is_in_comment
end)

local M = {
  s({
    trig = "todo-comment",
    -- show_condition = todo_comment_show_condition,
    desc = get_todo_keywords_description(),
  }, {
    f(get_comment_string_start),
    c(1, get_todo_keyword_snippet_choices()),
    f(get_comment_string_end),
  }),
  s({
    trig = "note-comment",
    -- show_condition = todo_comment_show_condition,
    desc = get_note_keywords_description(),
  }, {
    f(get_comment_string_start),
    c(1, get_note_keyword_snippet_choices()),
    f(get_comment_string_end),
  }),
  s({
    trig = "todo-keyword",
    -- show_condition = todo_keyword_show_condition,
    desc = get_todo_keywords_description(),
  }, {
    c(1, get_todo_keyword_snippet_choices()),
  }),
  s({
    trig = "note-keyword",
    -- show_condition = todo_keyword_show_condition,
    desc = get_note_keywords_description(),
  }, {
    c(1, get_note_keyword_snippet_choices()),
  }),
}

return M
