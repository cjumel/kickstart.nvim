-- Smart docstrings for functions, using treesitter to detect arguments and return types.

local ls = require("luasnip")
local ls_conditions = require("luasnip.extras.conditions")
local ls_conditions_show = require("luasnip.extras.conditions.show")

local custom_conditions = require("plugins.core.luasnip.conditions")

local d = ls.dynamic_node
local i = ls.insert_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local function_node_type = "function_definition"
local function_arg_node_types = {
  "identifier", -- argument without type or default value
  "default_parameter", -- argument with default value
  "typed_parameter", -- argument with type
  "typed_default_parameter", -- argument with type and default value
}
local function_ignored_arg_node_texts = { "self", "cls" } -- to avoid inserting them in the docstring

--- Check if the cursor is at the very beginning of a function body, just below the function definition.
---@return boolean
local function is_function_body_start()
  -- Check the previous line is not empty, as this case is not handled below
  local prev_row = vim.api.nvim_win_get_cursor(0)[1] - 2
  local prev_line = vim.api.nvim_buf_get_lines(0, prev_row, prev_row + 1, false)[1]
  if prev_line == "" then
    return false
  end

  -- Get node under cursor
  local node = vim.treesitter.get_node()
  if node == nil then
    return false
  end

  -- If the node is a function definition, it is the first non empty line of the function body (inside the function
  -- body, the nodes will be the "body" node or its children)
  return node:type() == function_node_type
end
local is_function_body_start_condition = ls_conditions.make_condition(is_function_body_start)

--- Get the argument snippets for a function node.
---@param function_node TSNode The Treesitter function node.
---@param insert_snippet_idx number The current index of insert snippet node.
---@return Node[], number The argument snippet nodes and the udpated value of insert_snippet_idx.
local function get_args_snippets(function_node, insert_snippet_idx)
  -- Get the arguments node, parent of all the argument nodes
  local arguments_node = function_node:field("parameters")[1]
  if arguments_node == nil then
    return {}, insert_snippet_idx
  end

  -- Find all the argument names
  local args = {}
  local bufnr = vim.api.nvim_get_current_buf()
  for argument_node in arguments_node:iter_children() do
    if vim.tbl_contains(function_arg_node_types, argument_node:type()) then
      local arg = vim.treesitter.get_node_text(argument_node, bufnr)
      arg = string.match(arg, "(%w+)") -- Remove type and default value
      if not vim.tbl_contains(function_ignored_arg_node_texts, arg) then
        table.insert(args, arg)
      end
    end
  end

  -- Create the argument snippets
  if #args == 0 then
    return {}, insert_snippet_idx
  end
  local snippets = { t({ "", "", "Args:" }) }
  for _, arg in ipairs(args) do
    vim.list_extend(snippets, { t({ "", "\t" .. arg .. ": " }), i(insert_snippet_idx) })
    insert_snippet_idx = insert_snippet_idx + 1
  end
  return snippets, insert_snippet_idx
end

--- Get the return snippets for a function node.
---@param function_node TSNode The Treesitter function node.
---@param insert_snippet_idx number The current index of snippet node.
---@return Node[], number The return snippet nodes and the udpated value of insert_snippet_idx.
local function get_return_snippets(function_node, insert_snippet_idx)
  -- Get the return type node text
  local return_type_node = function_node:field("return_type")[1]
  if return_type_node == nil then
    return {}, insert_snippet_idx
  end
  local bufnr = vim.api.nvim_get_current_buf()
  local return_type = vim.treesitter.get_node_text(return_type_node, bufnr)

  -- No return or yield case
  if return_type == "None" then
    return {}, insert_snippet_idx
  end

  -- Yield case
  local return_keyword = nil
  local yield_type_starts = { "Iterator", "Generator" }
  for _, yield_type_start in ipairs(yield_type_starts) do
    if return_type:sub(1, #yield_type_start) == yield_type_start then
      return_keyword = "Yields"
      break
    end
  end

  -- Return case
  if return_keyword == nil then
    return_keyword = "Returns"
  end

  local snippets = { t({ "", "", return_keyword .. ":", "\t" }), i(insert_snippet_idx) }
  insert_snippet_idx = insert_snippet_idx + 1
  return snippets, insert_snippet_idx
end

return {
  s({
    trig = "docstring",
    show_condition = is_function_body_start_condition * custom_conditions.line_begin * ls_conditions_show.line_end,
  }, {
    t('"""'),
    i(1),
    d(2, function(_)
      -- Get function node under the cursor
      local function_node = vim.treesitter.get_node()
      if function_node == nil or function_node:type() ~= function_node_type then
        return sn(nil, {})
      end

      local snippets = {}
      local args_snippets, insert_snippet_idx = get_args_snippets(function_node, 1)
      vim.list_extend(snippets, args_snippets)
      local return_snippets, _ = get_return_snippets(function_node, insert_snippet_idx)
      vim.list_extend(snippets, return_snippets)

      -- If at least a snippet is added, add a line break before the closing triple quotes
      if #snippets ~= 0 then
        table.insert(snippets, t({ "", "" }))
      end
      return sn(nil, snippets)
    end),
    t('"""'),
  }),
}
