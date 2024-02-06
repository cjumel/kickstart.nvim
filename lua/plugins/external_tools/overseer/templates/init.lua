local utils = require("utils")

local templates = utils.table.concat_arrays({
  require("plugins.external_tools.overseer.templates.poetry"),
  require("plugins.external_tools.overseer.templates.pre-commit"),
  require("plugins.external_tools.overseer.templates.pytest"),
})

-- Add a field defining the user command for each template
for _, template in ipairs(templates) do
  template.custom_user_command = utils.string.text_to_camelcase(template.name)
end

return templates
