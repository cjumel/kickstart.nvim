-- dispatch.vim
--
-- Dispatch commands like tests or builds asynchronously.

-- TODO:
-- - Setup commands: python file, pytest all, pytest file, poetry update

return {
  "tpope/vim-dispatch",
  cmd = "Dispatch",
  -- TODO: remove init function
  init = function()
    vim.keymap.set("n", "<leader>rs", "<cmd> Dispatch python % <CR>", { desc = "[R]un [S]cript" })
    vim.keymap.set(
      "n",
      "<leader>rt",
      "<cmd> Dispatch pytest % --no-header <CR>",
      { desc = "[R]un [T]ests" }
    )
  end,
}
