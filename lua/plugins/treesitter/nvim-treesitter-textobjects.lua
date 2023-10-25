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
  config = function()
    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

    -- Repeat movement with ; and ,
    -- ensure ; goes forward and , goes backward regardless of the last direction
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

    -- Define repeatable goto next/previous paragraph movements
    -- make sure forward function comes first
    local next_paragraph_repeat, prev_paragraph_repeat =
      ts_repeat_move.make_repeatable_move_pair(next_paragraph, previous_paragraph)
    vim.keymap.set({ "n", "x", "o" }, "[p", next_paragraph_repeat, { desc = "Next paragraph" })
    vim.keymap.set({ "n", "x", "o" }, "]p", prev_paragraph_repeat, { desc = "Previous paragraph" })

    -- Make diagnostic navigation repeatable
    -- make sure forward function comes first
    local next_diagnostic_repeat, prev_diagnostic_repeat =
      ts_repeat_move.make_repeatable_move_pair(vim.diagnostic.goto_next, vim.diagnostic.goto_prev)
    vim.keymap.set("n", "[d", next_diagnostic_repeat, { desc = "Next diagnostic" })
    vim.keymap.set("n", "]d", prev_diagnostic_repeat, { desc = "Previous diagnostic" })
  end,
}
