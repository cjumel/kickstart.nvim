local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node

local custom_show_conds = require("plugins.core.luasnip.show_conds")
local show_conds = require("luasnip.extras.conditions.show")

local M = {}

--- Create & output simple snippets for files in Oil buffers.
---@param file_names string[] List of file names to create snippets for.
---@return table
M.make_oil_file_snippets = function(file_names)
  local snippets = {}

  for _, file_name in ipairs(file_names) do
    table.insert(
      snippets,
      s({
        trig = file_name,
        show_condition = custom_show_conds.line_begin * show_conds.line_end,
      }, { t(file_name) })
    )
  end

  return snippets
end

return M
