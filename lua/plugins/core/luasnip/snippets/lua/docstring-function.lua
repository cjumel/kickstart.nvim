-- Smart docstrings for functions, using treesitter to detect parameters.

local ls = require("luasnip")
local ls_conditions = require("luasnip.extras.conditions")
local ls_conditions_show = require("luasnip.extras.conditions.show")

local custom_conditions = require("plugins.core.luasnip.conditions")

local c = ls.choice_node
local d = ls.dynamic_node
local i = ls.insert_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local function_node_type = "function_declaration"
local function_param_node_type = "identifier"
local function_ignored_param_node_text = "_" -- to avoid inserting it in the docstring

--- Check if the cursor is just above a function declaration.
---@return boolean
local function is_above_function()
  -- Get node below the cursor
  local row_next = vim.api.nvim_win_get_cursor(0)[1]
  local node = vim.treesitter.get_node({ pos = { row_next, 1 } })
  if node == nil then
    return false
  end
  return node:type() == function_node_type
end
local is_above_function_condition = ls_conditions.make_condition(is_above_function)

--- Get the parameter snippets for a function node.
---@param function_node TSNode The Treesitter function node.
---@param insert_snippet_idx number The current index of insert snippet node.
---@return Node[], number The argument snippet nodes and the udpated value of insert_snippet_idx.
local function get_params_snippets(function_node, insert_snippet_idx)
  -- Get the parameters node, parent of all the parameter nodes
  local params_node = function_node:field("parameters")[1]
  if params_node == nil then
    return {}, insert_snippet_idx
  end

  -- Find all the parameter names
  local params = {}
  local bufnr = vim.api.nvim_get_current_buf()
  for param_node in params_node:iter_children() do
    if param_node:type() == function_param_node_type then
      local param = vim.treesitter.get_node_text(param_node, bufnr)
      if param ~= function_ignored_param_node_text then
        table.insert(params, param)
      end
    end
  end

  -- Create the parameter snippets
  if #params == 0 then
    return {}, insert_snippet_idx
  end
  local snippets = {}
  for _, param in ipairs(params) do
    vim.list_extend(snippets, { t({ "", "---@param " .. param .. " " }), i(insert_snippet_idx) })
    insert_snippet_idx = insert_snippet_idx + 1
  end
  return snippets, insert_snippet_idx
end

--- Get the return snippets for a function node.
---@param insert_snippet_idx number The current index of insert snippet node.
---@return Node[], number The return snippet nodes and the udpated value of insert_snippet_idx.
local function get_return_snippets(_, insert_snippet_idx)
  local snippets = { t({ "", "---@return " }), c(insert_snippet_idx, { i(1), t("nil") }) }
  insert_snippet_idx = insert_snippet_idx + 1
  return snippets, insert_snippet_idx
end

return {
  s({
    trig = "docstring",
    show_condition = is_above_function_condition * custom_conditions.line_begin * ls_conditions_show.line_end,
  }, {
    t("--- "),
    i(1),
    d(2, function(_)
      -- Get function node below the cursor
      local row_next = vim.api.nvim_win_get_cursor(0)[1]
      local function_node = vim.treesitter.get_node({ pos = { row_next, 1 } })
      if function_node == nil or function_node:type() ~= function_node_type then
        return sn(nil, {})
      end

      local snippets = {}
      local params_snippets, insert_snippet_idx = get_params_snippets(function_node, 1)
      vim.list_extend(snippets, params_snippets)
      local return_snippets, _ = get_return_snippets(function_node, insert_snippet_idx)
      vim.list_extend(snippets, return_snippets)
      return sn(nil, snippets)
    end),
  }),
}
