local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node

local custom_show_conds = require("plugins.core.luasnip.show_conds")
local show_conds = require("luasnip.extras.conditions.show")

local M = {}

--- Get the show condition for a file name.
---@param file_name string The file name to create the show condition for.
---@param opts table<string, any>|nil Options for the show condition.
---@return function
local get_show_condition = function(file_name, opts)
  opts = opts or {}
  local condition = custom_show_conds.line_begin
    * show_conds.line_end
    * custom_show_conds.oil.file_not_exists(file_name)

  local project_type = opts.project_type
  if project_type == "python" then
    return condition * custom_show_conds.oil.is_in_python_project
  elseif project_type == "lua" then
    return condition * custom_show_conds.oil.is_in_lua_project
  else
    return condition
  end
end

--- Create & output simple snippets for files in Oil buffers.
---@param file_names string[] List of file names to create snippets for.
---@param opts table<string, any>|nil Options for the snippets.
---@return table
M.make_oil_file_snippets = function(file_names, opts)
  local snippets = {}

  for _, file_name in ipairs(file_names) do
    table.insert(
      snippets,
      s({
        trig = file_name,
        show_condition = get_show_condition(file_name, opts),
      }, { t(file_name) })
    )
  end

  return snippets
end

return M
