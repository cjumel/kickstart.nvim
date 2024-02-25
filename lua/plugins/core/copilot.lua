-- Copilot.vim
--
-- Vim implementation of GitHub's Copilot.
-- Invoke `:Copilot setup` when using for the first time.

return {
  "github/copilot.vim",
  -- For some reason, with `event = InsertEnter`, when entering insert mode for the first time
  -- directly in a buffer (e.g. not in Telescope), an event `github_copilot` takes around 900 ms
  -- and causes a significant latency
  event = { "BufNewFile", "BufReadPre" },
  config = function()
    vim.g.copilot_filetypes = { -- Enable or disable on some file types
      markdown = true,
    }

    -- The plugin sets:
    --   <C-i> (or <Tab>) as the regular completion key
    --   <C-]> (<C-$> for me) to discard the suggestion
    vim.keymap.set(
      "i",
      "î", -- <M-i>
      "<Plug>(copilot-accept-word)",
      { desc = "Copilot: accept one word" }
    )
    vim.keymap.set(
      "i",
      "œ", -- <M-o>
      "<Plug>(copilot-accept-line)",
      { desc = "Copilot: accept one line" }
    )
    vim.keymap.set(
      "i",
      "Ï", -- <M-j>
      "<Plug>(copilot-next)",
      { desc = "Copilot: next suggestion" }
    )
    vim.keymap.set(
      "i",
      "È", -- <M-k>
      "<Plug>(copilot-previous)",
      { desc = "Copilot: previous suggestion" }
    )
  end,
}
