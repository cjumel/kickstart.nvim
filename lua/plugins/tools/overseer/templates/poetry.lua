local template_builder = require("plugins.tools.overseer.template_builder")

local condition_callback = function(_) return vim.fn.filereadable("poetry.lock") == 1 end

return {
  template_builder.cmd({ "poetry", "add" }, { condition_callback = condition_callback, has_args = true }),
  template_builder.cmd({ "poetry", "update" }, { condition_callback = condition_callback }),
}
