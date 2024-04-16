-- Smart docstring snippets for Python, using treesitter to detect arguments or attributes
-- and automatically insert them in the docstring.

local ls = require("luasnip")

local custom_conds = require("plugins.core.luasnip.conditions")
local show_conds = require("luasnip.extras.conditions.show")

local d = ls.dynamic_node
local i = ls.insert_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local is_in_function_empty_line = custom_conds.ts.is_in_function * custom_conds.line_begin * show_conds.line_end
local is_in_class_empty_line = custom_conds.ts.is_in_class * custom_conds.line_begin * show_conds.line_end

return {

  -- Function version
  s({ trig = "docstring", show_condition = is_in_function_empty_line }, {
    t('"""'),
    i(1),
    d(2, function(_)
      local snippets = {}
      local insert_snippet_idx = 1
      local bufnr = vim.api.nvim_get_current_buf()

      local function_node = vim.treesitter.get_node()
      if function_node == nil or function_node:type() ~= "function_definition" then
        return sn(nil, snippets)
      end

      local parameters_node = nil
      local type_node = nil
      for function_child_node in function_node:iter_children() do
        local function_child_node_type = function_child_node:type()
        if function_child_node_type == "parameters" then
          parameters_node = function_child_node
          if type_node ~= nil then
            break
          end
        elseif function_child_node_type == "type" then
          type_node = function_child_node
          if parameters_node ~= nil then
            break
          end
        end
      end

      if parameters_node ~= nil then
        local args = {}
        for parameter_node in parameters_node:iter_children() do
          -- Children types can be "identifier" or "typed_parameter" or something else in which case
          -- they are not relevant (correspond to parenthesis or commas for example)
          local parameter_type = parameter_node:type()
          local arg = nil
          if parameter_type == "identifier" then -- Parameter without type
            arg = vim.treesitter.get_node_text(parameter_node, bufnr)
          elseif parameter_type == "typed_parameter" then
            local arg_with_type = vim.treesitter.get_node_text(parameter_node, bufnr)
            arg = arg_with_type:match("([^:]+):")
          end
          if arg ~= nil and arg ~= "self" and arg ~= "cls" then
            table.insert(args, arg)
          end
        end

        if #args ~= 0 then
          table.insert(snippets, t({ "", "", "Args:" }))
          for _, arg in ipairs(args) do
            table.insert(snippets, t({ "", "\t" .. arg .. ": " }))
            table.insert(snippets, i(insert_snippet_idx))
            insert_snippet_idx = insert_snippet_idx + 1
          end
        end
      end

      -- Detect the relevant output keyword ("Returns" or "Yields") and output it, or nil when
      -- none is found.
      local function get_output_keyword(node)
        if node == nil then
          return nil
        end

        local return_type = vim.treesitter.get_node_text(node, bufnr)
        if return_type == "None" then
          return nil
        end

        local yield_starts_and_excludes = {
          { "Iterator", "Iterator[None]" },
          { "Generator", "Generator[None, None, None]" },
        }
        for _, yield_start_and_exclude in ipairs(yield_starts_and_excludes) do
          local yield_start = yield_start_and_exclude[1]
          local yield_exclude = yield_start_and_exclude[2]
          if return_type:sub(1, #yield_start) == yield_start then
            if return_type ~= yield_exclude then
              return "Yields"
            else
              return nil
            end
          end
        end

        return "Returns"
      end

      local keyword = get_output_keyword(type_node)
      if keyword ~= nil then
        table.insert(snippets, t({ "", "", keyword .. ":", "\t" }))
        table.insert(snippets, i(insert_snippet_idx))
        insert_snippet_idx = insert_snippet_idx + 1
      end

      -- If at least an arg, return or yield is inserted, add a line break
      if insert_snippet_idx ~= 1 then
        table.insert(snippets, t({ "", "" }))
      end

      return sn(nil, snippets)
    end),
    t('"""'),
  }),

  -- Class version
  s({ trig = "docstring", show_condition = is_in_class_empty_line }, {
    t('"""'),
    i(1),
    d(2, function(_)
      local bufnr = vim.api.nvim_get_current_buf()

      local node = vim.treesitter.get_node()
      if node == nil or node:type() ~= "class_definition" then
        return sn(nil, {})
      end
      local body_node = node:field("body")[1]
      if body_node == nil then
        return sn(nil, {})
      end

      local attributes = {}

      for body_child_node in body_node:iter_children() do
        -- Class level attributes
        if body_child_node:type() == "expression_statement" then
          local assignment_node = body_child_node:child(0)
          if assignment_node ~= nil and assignment_node:type() == "assignment" then
            local left_assignment_node = assignment_node:field("left")[1]
            if left_assignment_node ~= nil then
              local attribute = vim.treesitter.get_node_text(left_assignment_node, bufnr)
              table.insert(attributes, attribute)
            end
          end

        -- __init__ attributes
        elseif body_child_node:type() == "function_definition" then
          local function_name_node = body_child_node:field("name")[1]
          if function_name_node ~= nil then
            local function_name = vim.treesitter.get_node_text(function_name_node, bufnr)
            if function_name == "__init__" then
              local function_body_node = body_child_node:field("body")[1]
              if function_body_node ~= nil then
                for function_body_child_node in function_body_node:iter_children() do
                  if function_body_child_node:type() == "expression_statement" then
                    local assignment_node = function_body_child_node:child(0)
                    if assignment_node ~= nil and assignment_node:type() == "assignment" then
                      local left_assignment_node = assignment_node:field("left")[1]
                      if left_assignment_node ~= nil then
                        local prefixed_attribute = vim.treesitter.get_node_text(left_assignment_node, bufnr)
                        -- Only keep assignments to self
                        if prefixed_attribute:sub(1, 5) == "self." then
                          -- Remove "self." prefix
                          local attribute = prefixed_attribute:sub(6)
                          table.insert(attributes, attribute)
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end

      -- Don't take into account private attributes and duplicates
      local attributes_filtered = {}
      for _, attribute in ipairs(attributes) do
        if attribute:sub(1, 1) ~= "_" and not vim.tbl_contains(attributes_filtered, attribute) then
          table.insert(attributes_filtered, attribute)
        end
      end

      local snippets = {}
      local insert_snippet_idx = 1
      if #attributes_filtered ~= 0 then
        table.insert(snippets, t({ "", "", "Attributes:" }))
        for _, attribute in ipairs(attributes_filtered) do
          table.insert(snippets, t({ "", "\t" .. attribute .. ": " }))
          table.insert(snippets, i(insert_snippet_idx))
          insert_snippet_idx = insert_snippet_idx + 1
        end
        table.insert(snippets, t({ "", "" }))
      end

      return sn(nil, snippets)
    end),
    t('"""'),
  }),
}
