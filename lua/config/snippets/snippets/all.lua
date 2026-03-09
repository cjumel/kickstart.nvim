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

local keywords = { "TODO", "FIXME", "BUG", "NOTE", "HACK", "WARN", "PERF" }

local excluded_filetypes = {
  "gitcommit",
  "markdown", -- Todo-comments are not recognized by todo-comments.nvim anyway
}

local support_todo_comment_cond = ls_conds.make_condition(
  function()
    return not (
      vim.bo.buftype ~= ""
      or vim.tbl_contains(excluded_filetypes, vim.bo.filetype)
      or vim.bo.commentstring == ""
    )
  end
)

local todo_comment_snippets = {
  s({
    trig = "todo-comment",
    show_condition = snippet_conds.line_end * support_todo_comment_cond * snippet_conds.code,
  }, {
    f(get_comment_string_start),
    c(1, {
      sn(nil, { t("TODO: "), r(1, "content", i(nil)) }),
      sn(nil, { t("TODO("), i(1), t("): "), r(2, "content") }),
    }),
    f(get_comment_string_end),
  }),
}
for _, keyword in ipairs(keywords) do
  table.insert(
    todo_comment_snippets,
    s({
      trig = string.lower(keyword) .. "-keyword",
      show_condition = snippet_conds.line_end * support_todo_comment_cond * snippet_conds.comment,
    }, {
      c(1, {
        sn(nil, { t(keyword .. ": "), r(1, "content", i(nil)) }),
        sn(nil, { t(keyword .. "("), i(1), t("): "), r(2, "content") }),
      }),
    })
  )
end

snippets = vim.list_extend(snippets, todo_comment_snippets)

return snippets
