-- [[ Keymaps ]]

local actions = require("config.actions")
local keymap = require("config.keymap")

keymap.set_buffer("n", "q", actions.quit, { desc = "Quit" })

local key_to_action = {
  p = "pick",
  r = "reword",
  e = "edit",
  s = "squash",
  f = "fixup",
  x = "exec",
  b = "break",
  d = "drop",
  l = "label",
  t = "reset",
  m = "merge",
  u = "update-ref",
}
for key, action in pairs(key_to_action) do
  keymap.set_buffer(
    "n",
    "<localleader>" .. key,
    "^ce" .. action .. "<Esc>^j",
    { desc = 'Change keyword for "' .. action .. '"' }
  )
end
