-- Provide todo-comment snippets, either using Treesitter to detect if we are within a comment or a string, or not, in
-- case it's not available. The original implementation is a simpler version of:
-- https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets#all---todo-commentsnvim-snippets
-- It was then simplified to avoid relying on the `Comment.nvim` plugin and use only builtin Neovim features.

local conds = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")
local ls_show_conds = require("luasnip.extras.conditions.show")

local c = ls.choice_node
local f = ls.function_node
local i = ls.insert_node
local r = ls.restore_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local M = {}

--- Get the comment string start and end, taking the current file type into account.
---@return string[]
local function get_comment_strings()
  -- Fetch the comment string for the filetype (e.g. '-- %s' for `lua`)
  -- Compared to the initial implementation using `Comment.nvim`, this doesn't work for code regions with different
  --  comment string than the filetype (e.g. code embedded in Markdown files), but this is good enough for me
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

for _, mode in ipairs({ "ts", "no_ts" }) do
  local snippets = {}

  local todo_comment_show_condition
  if mode == "ts" then
    todo_comment_show_condition = ls_show_conds.line_end
      * conds.make_treesitter_node_exclusion_condition({
        "comment",
        "comment_content",
        "string",
        "string_start",
        "string_content",
      })
  else
    todo_comment_show_condition = ls_show_conds.line_end * -conds.is_comment_start
  end
  table.insert(
    snippets,
    s({
      trig = "todo-comment",
      show_condition = todo_comment_show_condition,
      desc = [[
Choices:
- `TODO_`
- `TODO`]],
    }, {
      f(get_comment_string_start),
      c(1, {
        sn(nil, { t("TODO_: "), r(1, "content", i(nil)) }),
        sn(nil, { t("TODO: "), r(1, "content") }),
      }),
      f(get_comment_string_end),
    })
  )

  local todo_keyword_show_condition
  if mode == "ts" then
    todo_keyword_show_condition = conds.make_treesitter_node_inclusion_condition({
      "comment",
      "comment_content",
    }) * conds.is_comment_start
  else
    todo_keyword_show_condition = conds.is_comment_start
  end
  for _, keyword in ipairs({ -- Let's only add the subset useful for me of keywords which are recognized
    "TODO_",
    "TODO",
    "FIXME",
    "BUG",
    "HACK",
    "WARN",
    "PERF",
    "TEST",
    "NOTE",
  }) do
    table.insert(
      snippets,
      s({
        trig = keyword .. ": ",
        show_condition = todo_keyword_show_condition,
        desc = "`" .. keyword .. ": ..`",
      }, {
        t(keyword .. ": "),
        i(1),
      })
    )
  end

  M[mode] = snippets
end

return M
