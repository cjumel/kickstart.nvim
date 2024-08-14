-- Provide todo-comment snippets, either using Treesitter to detect if we are within a comment or a string, or not using
-- it at all, in case it's not available.
-- Original implementation is a simpler version of
-- https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets#all---todo-commentsnvim-snippets
-- It was then simplified to avoid relying on the `Comment.nvim` plugin

local ls = require("luasnip")

local custom_conditions = require("plugins.core.luasnip.conditions")

local c = ls.choice_node
local f = ls.function_node
local i = ls.insert_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

--- Get the comment string start and end, depending on the current file type.
---@return string[]
local function get_comment_strings()
  -- Fetch the comment string for the filetype (e.g. '-- %s' for `lua`)
  -- Compared to the initial implementation using `Comment.nvim`, this doesn't work for code regions with different
  -- comment string than the filetype (e.g. code embedded in Markdown files)
  local cstring = vim.bo.commentstring

  -- Initially, comment strings are ready to be used by `format`, so we want to split the left and right side
  -- This implementation is taken from `require("Comment.nvim.utils").unwrap_cstr`
  local left, right = string.match(cstring, "(.*)%%s(.*)")
  assert(
    (left or right),
    { msg = string.format("Invalid commentstring for %s! Read `:h commentstring` for help.", vim.bo.filetype) }
  )
  left, right = vim.trim(left), vim.trim(right)

  -- Create & output the final table
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

local todo_comment_keywords = {
  "NOW", -- Custom keyword for stuff to do right now
  "TODO",
  "FIXME",
  "BUG",
  "HACK",
  "WARN",
  "PERF",
  "TEST",
  "NOTE",
}

--- Get the todo-comment keyword option snippet nodes.
---@return table todo_comment_sn_options Table of todo-comment keyword option snippet nodes.
local function get_todo_comment_sn_options()
  local todo_comment_sn_options = {}
  for _, keyword in ipairs(todo_comment_keywords) do
    table.insert(todo_comment_sn_options, sn(nil, { t(keyword), t(": "), i(1) }))
  end
  return todo_comment_sn_options
end

return {
  no_ts = {
    s({ trig = "todo-comment" }, {
      f(get_comment_string_start),
      c(1, get_todo_comment_sn_options()),
      f(get_comment_string_end),
    }),
  },
  ts = {
    s({ trig = "todo-comment", show_condition = custom_conditions.is_in_code }, {
      f(get_comment_string_start),
      c(1, get_todo_comment_sn_options()),
      f(get_comment_string_end),
    }),
    s({ trig = "todo-comment", show_condition = custom_conditions.is_in_comment }, {
      c(1, get_todo_comment_sn_options()),
    }),
  },
}
