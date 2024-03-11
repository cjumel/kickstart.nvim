local cond_obj = require("luasnip.extras.conditions")

local utils = require("utils")

local M = {}

M.file_not_exists = function(name)
  return cond_obj.make_condition(function(_)
    return not utils.dir.contain_files({ name }, nil, { fallback = "oil" })
  end)
end

M.is_in_python_project = cond_obj.make_condition(function(_)
  return utils.project.is_python()
end)

M.is_in_lua_project = cond_obj.make_condition(function(_)
  return utils.project.is_lua()
end)

return M
