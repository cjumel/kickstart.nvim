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

    -- The plugin sets <C-i> (or <Tab>) as the regular completion key
    vim.keymap.set(
      "i",
      "<C-]>", -- Actually <C-$> on my setup
      "<Plug>(copilot-accept-word)"
    )
    vim.keymap.set(
      "i",
      "<C-\\>", -- Actually <C-`> on my setup
      "<Plug>(copilot-accept-line)"
    )
    vim.keymap.set(
      "i",
      "£", -- Actually <M-`> on my setup
      "<Plug>(copilot-next)"
    )
    vim.keymap.set(
      "i",
      "€", -- Actually <M-$> on my setup
      "<Plug>(copilot-previous)"
    )
  end,
}
