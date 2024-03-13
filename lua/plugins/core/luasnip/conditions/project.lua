local cond_obj = require("luasnip.extras.conditions")

local utils = require("utils")

local M = {}

M.is_python = cond_obj.make_condition(function(_)
  return utils.project.is_python()
end)

M.is_lua = cond_obj.make_condition(function(_)
  return utils.project.is_lua()
end)

return M
