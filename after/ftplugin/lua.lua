-- [[ Keymaps ]]

vim.keymap.set("n", "<localleader>m", function()
  local module_ = require("lang_utils.lua").get_module()
  vim.fn.setreg('"', module_)
  vim.notify('Yanked to register `"`:\n```\n' .. module_ .. "\n```")
end, { buffer = true, desc = "Yank [M]odule" })

vim.keymap.set("n", "<localleader>r", function()
  local run_command = [[dofile("]] .. vim.fn.expand("%:p:.") .. [[")]]
  vim.fn.setreg("+", run_command)
  vim.notify("Yanked to register `+`:\n```\n" .. run_command .. "\n```")
end, { buffer = true, desc = "Yank [R]EPL run command" })
