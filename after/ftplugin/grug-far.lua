-- [[ Keymaps ]]

vim.keymap.set("n", "<localleader>h", function()
  local state = unpack(require("grug-far").toggle_flags({ "--hidden" }))
  vim.notify("grug-far: toggled --hidden " .. (state and "ON" or "OFF"))
end, { desc = "Toggle --hidden flag", buffer = true })

vim.keymap.set("n", "<localleader>f", function()
  local grug_far = require("grug-far")
  local state = unpack(grug_far.toggle_flags({ "--fixed-strings" }))
  vim.notify("grug-far: toggled --fixed-strings " .. (state and "ON" or "OFF"))
end, { desc = "Toggle --fixed-strings flag", buffer = true })
