local ls = require("luasnip")
local show_conds = require("luasnip.extras.conditions.show")

local custom_conds = require("plugins.core.luasnip.conditions")

local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

local M = {}

--- Create & output simple snippets for files in Oil buffers.
---@param file_names string[] List of file names to create snippets for.
---@param opts table<string, any>|nil Options for the snippets.
---@return table
M.get_simple_file_snippets = function(file_names, opts)
  opts = opts or {}
  local project_type = opts.project_type

  local show_condition = custom_conds.ts.line_begin * show_conds.line_end
  if project_type == "python" then
    show_condition = show_condition * custom_conds.project.is_python
  elseif project_type == "lua" then
    show_condition = show_condition * custom_conds.project.is_lua
  end

  local snippets = {}
  for _, file_name in ipairs(file_names) do
    table.insert(
      snippets,
      s({
        trig = file_name,
        show_condition = show_condition * custom_conds.oil.file_not_exists(file_name),
      }, { t(file_name) })
    )
  end

  return snippets
end

--- Create & output a snippet for a given file type in Oil buffers.
---@param filetype string File type to create a snippet for.
---@param extension string|nil File extension to use for the snippet. Defaults to the file type.
---@return table
M.get_filetype_snippet = function(filetype, extension)
  extension = extension or filetype

  local show_condition = custom_conds.ts.line_begin * show_conds.line_end
  if filetype == "python" then
    show_condition = show_condition * custom_conds.project.is_python
  elseif filetype == "lua" then
    show_condition = show_condition * custom_conds.project.is_lua
  end

  return s({
    trig = filetype .. "-file",
    show_condition = show_condition,
  }, { i(1, "name"), t("." .. extension) })
end

return M
