-- nvim-treesitter-textobject
--
-- Syntax aware text-objects, select, move, swap, and peek support.

local next_paragraph = function()
  vim.cmd("normal! }")
end
local previous_paragraph = function()
  vim.cmd("normal! {")
end

return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  event = { "BufNewFile", "BufReadPre" },
  config = function()
    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

    -- Repeat movement with ; (forward) and , (backward)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_previous)

    -- Repeatable paragraph movements
    local next_paragraph_repeat, prev_paragraph_repeat =
      ts_repeat_move.make_repeatable_move_pair(next_paragraph, previous_paragraph)
    vim.keymap.set({ "n", "x", "o" }, "[p", next_paragraph_repeat, { desc = "Next paragraph" })
    vim.keymap.set({ "n", "x", "o" }, "]p", prev_paragraph_repeat, { desc = "Previous paragraph" })

    -- Repeatable diagnostic movements
    local next_diagnostic_repeat, prev_diagnostic_repeat =
      ts_repeat_move.make_repeatable_move_pair(vim.diagnostic.goto_next, vim.diagnostic.goto_prev)
    vim.keymap.set("n", "[?", next_diagnostic_repeat, { desc = "Next diagnostic" })
    vim.keymap.set("n", "]?", prev_diagnostic_repeat, { desc = "Previous diagnostic" })
  end,
}
