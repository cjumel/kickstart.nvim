-- Copilot.vim
--
-- Vim implementation of GitHub's Copilot.
-- Invoke `:Copilot setup` when using for the first time.

return {
  "github/copilot.vim",
  event = { "BufNewFile", "BufReadPre" },
  config = function()
    vim.keymap.set("i", "<S-Tab>", "<Plug>(copilot-accept-word)")
  end,
}
