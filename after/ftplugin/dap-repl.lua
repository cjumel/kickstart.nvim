-- [[ Keymaps ]]

-- Fix delete word keymaps
vim.keymap.set("i", "<C-w>", "<C-S-w>", { desc = "Delete word", buffer = true })
vim.keymap.set("i", "<M-BS>", "<C-S-w>", { desc = "Delete word", buffer = true })

-- Keymaps to go through history like with the arrow keys (<C-n> & <C-p> are taken by nvim-cmp)
vim.keymap.set(
  "i",
  "<C-]>", -- <C-$>
  function() require("dap.repl").on_up() end,
  { desc = "Previous history item", buffer = true }
)
vim.keymap.set(
  "i",
  "<C-\\>", -- <C-`>
  function() require("dap.repl").on_down() end,
  { desc = "Next history item", buffer = true }
)
