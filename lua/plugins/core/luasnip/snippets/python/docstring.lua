local conds = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")
local ls_show_conds = require("luasnip.extras.conditions.show")

local d = ls.dynamic_node
local i = ls.insert_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

return {

  s({
    trig = "Args ..",
    show_condition = conds.line_begin
      * ls_show_conds.line_end
      * conds.make_treesitter_node_ancestors_inclusion_condition({
        "string_content",
        "string",
        "expression_statement",
        "block",
        "function_definition",
      }),
  }, {
    t("Args:"),
    d(1, function(_)
      local node = vim.treesitter.get_node()
      while node ~= nil and node:type() ~= "function_definition" and node:parent() ~= nil do
        node = node:parent()
      end
      if node == nil then
        return sn(nil, {})
      end

      local parameters_node = node:field("parameters")[1]
      if parameters_node == nil then
        return sn(nil, {})
      end

      local argument_names = {}
      local bufnr = vim.api.nvim_get_current_buf()
      for argument_node in parameters_node:iter_children() do
        if
          vim.tbl_contains({
            "identifier", -- argument without type or default value
            "default_parameter", -- argument with default value
            "typed_parameter", -- argument with type
            "typed_default_parameter", -- argument with type and default value
          }, argument_node:type())
        then
          local argument_name = vim.treesitter.get_node_text(argument_node, bufnr)
          argument_name = string.match(argument_name, "(%w+)") -- Remove type and default value
          if not vim.tbl_contains({ "self", "cls" }, argument_name) then
            table.insert(argument_names, argument_name)
          end
        end
      end

      local snippets = {}
      for argument_idx, argument_name in ipairs(argument_names) do
        vim.list_extend(snippets, { t({ "", "\t" .. argument_name .. ": " }), i(argument_idx) })
      end
      return sn(nil, snippets)
    end),
  }),

  s({
    trig = "Attributes ..",
    show_condition = conds.line_begin
      * ls_show_conds.line_end
      * conds.make_treesitter_node_ancestors_inclusion_condition({
        "string_content",
        "string",
        "expression_statement",
        "block",
        "class_definition",
      }),
  }, {
    t("Attributes:"),
    d(1, function(_)
      local node = vim.treesitter.get_node()
      while node ~= nil and node:type() ~= "class_definition" and node:parent() ~= nil do
        node = node:parent()
      end
      if node == nil then
        return sn(nil, {})
      end

      local body_node = node:field("body")[1]
      if body_node == nil then
        return sn(nil, {})
      end

      local attribute_names = {}
      local bufnr = vim.api.nvim_get_current_buf()
      for body_child_node in body_node:iter_children() do
        if body_child_node:type() == "expression_statement" then -- Class level attributes
          local assignment_node = body_child_node:child(0)
          if assignment_node ~= nil and assignment_node:type() == "assignment" then
            local left_assignment_node = assignment_node:field("left")[1]
            if left_assignment_node ~= nil then
              local attribute_name = vim.treesitter.get_node_text(left_assignment_node, bufnr)
              table.insert(attribute_names, attribute_name)
            end
          end
        elseif body_child_node:type() == "function_definition" then -- __init__ attributes
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
                          local attr = prefixed_attribute:sub(6)
                          table.insert(attribute_names, attr)
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

      local filtered_attribute_names = {}
      for _, attribute_name in ipairs(attribute_names) do
        local attribute_is_private = attribute_name:sub(1, 1) == "_"
        local attribute_is_duplicate = vim.tbl_contains(filtered_attribute_names, attribute_name)
        if not attribute_is_private and not attribute_is_duplicate then
          table.insert(filtered_attribute_names, attribute_name)
        end
      end
      attribute_names = filtered_attribute_names

      local snippets = {}
      for attribute_idx, attribute_name in ipairs(attribute_names) do
        vim.list_extend(snippets, { t({ "", "\t" .. attribute_name .. ": " }), i(attribute_idx) })
      end
      return sn(nil, snippets)
    end),
  }),

  s({
    trig = "Raises ..",
    show_condition = conds.line_begin
      * ls_show_conds.line_end
      * conds.make_treesitter_node_ancestors_inclusion_condition({
        "string_content",
        "string",
        "expression_statement",
        "block",
        "function_definition",
      }),
  }, {
    t({ "Raises:", "\t" }),
  }),

  s({
    trig = "Returns ..",
    show_condition = conds.line_begin
      * ls_show_conds.line_end
      * conds.make_treesitter_node_ancestors_inclusion_condition({
        "string_content",
        "string",
        "expression_statement",
        "block",
        "function_definition",
      }),
  }, {
    t({ "Returns:", "\t" }),
  }),

  s({
    trig = "Yields ..",
    show_condition = conds.line_begin
      * ls_show_conds.line_end
      * conds.make_treesitter_node_ancestors_inclusion_condition({
        "string_content",
        "string",
        "expression_statement",
        "block",
        "function_definition",
      }),
  }, {
    t({ "Yields:", "\t" }),
  }),
}
