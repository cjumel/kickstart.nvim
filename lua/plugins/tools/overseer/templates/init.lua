local utils = require("utils")

local templates = utils.table.concat_arrays({
  require("plugins.tools.overseer.templates.poetry"),
  require("plugins.tools.overseer.templates.pre-commit"),
  require("plugins.tools.overseer.templates.pytest"),
  require("plugins.tools.overseer.templates.python"),
})

-- Add a field defining the user command for each template
for _, template in ipairs(templates) do
  template._user_command = utils.string.text_to_camelcase(template.name)
end

return templates
