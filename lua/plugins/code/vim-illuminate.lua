-- vim-illuminate
--
-- Vim plugin for automatically highlighting other uses of the word under the cursor using either
-- LSP, Tree-sitter, or regex matching.

return {
  "RRethy/vim-illuminate",
  lazy = true,
  opts = {
    providers = { "lsp" }, -- Only enable LSP to decrease false positives
  },
  config = function(_, opts)
    require("illuminate").configure(opts)

    local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
    local next_reference, prev_reference = ts_repeat_move.make_repeatable_move_pair(
      require("illuminate").goto_next_reference,
      require("illuminate").goto_prev_reference
    )
    vim.keymap.set({ "n", "x", "o" }, "[r", next_reference, { desc = "Next reference" })
    vim.keymap.set({ "n", "x", "o" }, "]r", prev_reference, { desc = "Previous reference" })
  end,
}
