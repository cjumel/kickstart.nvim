local utils = require("utils")

local modules = require("plugins.external_tools.overseer.modules")

local global_keychains = {
  ["<leader>o"] = { name = "[O]verseer", _ = "which_key_ignore" },
  ["<leader>op"] = { name = "[O]verseer: [P]..." },
}

local module_keychains = {}
for _, module in ipairs(modules) do
  if module.keychains then
    table.insert(module_keychains, module.keychains)
  end
end

return utils.table.concat_dicts({
  global_keychains,
  utils.table.concat_dicts(module_keychains),
})
