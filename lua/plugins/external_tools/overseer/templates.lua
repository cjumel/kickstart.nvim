local utils = require("utils")

local modules = require("plugins.external_tools.overseer.modules")

local module_templates = {}
for _, module in ipairs(modules) do
  if module.templates then
    table.insert(module_templates, module.templates)
  end
end

return utils.table.concat_arrays(module_templates)
