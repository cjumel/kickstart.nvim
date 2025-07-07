-- [[ Keymaps ]]

local yank = require("yank")
local function yank_module()
  local module = require("lang_utils.lua").get_module()
  yank.with_notification(module)
end
local function yank_repl_command()
  local repl_command = [[dofile("]] .. vim.fn.expand("%:p:.") .. [[")]]
  yank.with_notification(repl_command)
end
vim.keymap.set("n", "<leader>ym", yank_module, { desc = "[Y]ank: [M]odule", buffer = true })
vim.keymap.set("n", "<leader>yr", yank_repl_command, { desc = "[Y]ank: [R]EPL command", buffer = true })
