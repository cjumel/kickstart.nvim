-- Copilot.vim
--
-- (Neo)Vim plugin for GitHub's Copilot. This plugins uses OpenAI Codex to suggest code completions using virtual text,
-- so it's nicely complementary with floating-window completion tools, like nvim-cmp. However, since the model is not
-- run locally, this plugins require an active internet connection and an active subscription.

return {
  "github/copilot.vim",
  -- When lazy-loading more agressively (e.g. on `InsertEnter` event), the plugin doesn't write properly right away
  event = { "BufNewFile", "BufReadPre" },
  cmd = { "Copilot" }, -- For other plugins using directly the command, like the settings in Hydra.nvim
  config = function()
    vim.g.copilot_filetypes = { markdown = true } -- Enable Copilot on Markdown

    -- The plugin sets <C-i> as the regular completion key; let's add <C-$> & <C-`> to accept word or line
    vim.keymap.set("i", "<C-]>", "<Plug>(copilot-accept-word)", { desc = "Copilot: accept one word" })
    vim.keymap.set("i", "<C-\\>", "<Plug>(copilot-accept-line)", { desc = "Copilot: accept one line" })
    -- Use <M-,> & <M-;> to navigate through the suggestions
    vim.keymap.set("i", "∞", "<Plug>(copilot-next)", { desc = "Copilot: next suggestion" })
    vim.keymap.set("i", "…", "<Plug>(copilot-previous)", { desc = "Copilot: previous suggestion" })
  end,
}
