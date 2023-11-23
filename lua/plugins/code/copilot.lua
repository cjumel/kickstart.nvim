-- Copilot.vim
--
-- Vim implementation of GitHub's Copilot.
-- Invoke `:Copilot setup` when using for the first time.

return {
  "github/copilot.vim",
  event = { "BufNewFile", "BufReadPre" },
  config = function()
    -- <Tab> is the regular completion key
    vim.keymap.set("i", "<S-Tab>", "<Plug>(copilot-accept-word)")
    vim.keymap.set("i", "<C-s>", "<Plug>(copilot-dismiss)") -- stop
  end,
}
