local templates = require("plugins.external_tools.overseer.templates")

local commands = {}
for _, template in ipairs(templates) do
  table.insert(commands, template.custom_user_command)
end

return commands
