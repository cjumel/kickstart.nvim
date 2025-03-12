-- [[ Keymaps ]]

vim.keymap.set("n", "<leader>ym", function()
  local module_ = require("lang_utils.lua").get_module()
  vim.fn.setreg('"', module_)
  vim.notify('Yanked to register `"`:\n```\n' .. module_ .. "\n```")
end, { buffer = true, desc = "[Y]ank: [M]odule" })

vim.keymap.set("n", "<leader>yr", function()
  local run_command = [[dofile("]] .. vim.fn.expand("%:p:.") .. [[")]]
  vim.fn.setreg("+", run_command)
  vim.notify("Yanked to register `+`:\n```\n" .. run_command .. "\n```")
end, { buffer = true, desc = "[Y]ank: REPL [R]un command" })
