-- Repeatable keymaps to move the cursor to next or previous occurence of something

local utils = require("utils")

utils.keymap.set_move_pair(
  { "[s", "]s" },
  { function() vim.cmd("normal )") end, function() vim.cmd("normal (") end },
  { { desc = "Next sentence" }, { desc = "Previous sentence" } }
)
utils.keymap.set_move_pair(
  { "[p", "]p" },
  { function() vim.cmd("normal }") end, function() vim.cmd("normal {") end },
  { { desc = "Next paragraph" }, { desc = "Previous paragraph" } }
)

-- Dianostics can be errors, warnings, information messages or hints
utils.keymap.set_move_pair(
  { "[d", "]d" },
  { vim.diagnostic.goto_next, vim.diagnostic.goto_prev },
  { { desc = "Next diagnostic" }, { desc = "Previous diagnostic" } }
)
utils.keymap.set_move_pair({ "[e", "]e" }, {
  function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end,
  function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end,
}, { { desc = "Next error" }, { desc = "Previous error" } })

-- Conflict markers follow one of the 3 following forms at the start of a line:
-- `<<<<<<< <some text>`, ` =======` or ` >>>>>>> <some text>`
-- "^" forces the search pattern matches to be at the start of a line
local conflict_pattern = "^<<<<<<< \\|^=======\\|^>>>>>>> "
utils.keymap.set_move_pair({ "[=", "]=" }, {
  function() vim.fn.search(conflict_pattern) end,
  function() vim.fn.search(conflict_pattern, "b") end,
}, { { desc = "Next conflict mark" }, { desc = "Previous conflict mark" } })
