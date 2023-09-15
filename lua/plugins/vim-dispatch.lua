-- dispatch.vim
--
-- Dispatch commands like tests or builds asynchronously.

return {
  "tpope/vim-dispatch",
  cmd = "Dispatch",
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
