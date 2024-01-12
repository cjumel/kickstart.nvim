local utils = require("utils")

local modules = require("plugins.external_tools.overseer.modules")

local module_keymaps = {}
for _, module in ipairs(modules) do
  if module.keymaps then
    table.insert(module_keymaps, module.keymaps)
  end
end

return utils.table.concat_arrays(module_keymaps)
