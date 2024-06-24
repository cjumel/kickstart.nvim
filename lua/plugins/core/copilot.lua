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
    vim.g.copilot_no_tab_map = true -- Don't automatically map the <Tab> key
    vim.g.copilot_filetypes = { markdown = true } -- Enable Copilot on additional filetypes

    vim.keymap.set("i", "<C-]>", "<Plug>(copilot-accept-word)", { desc = "Copilot: accept one word" })
    vim.keymap.set("i", "<C-\\>", "<Plug>(copilot-accept-line)", { desc = "Copilot: accept one line" })
    vim.keymap.set(
      "i",
      "<M-CR>", -- <C-CR>
      'copilot#Accept("")',
      { expr = true, replace_keycodes = false, desc = "Copilot: accept" }
    )

    vim.keymap.set("i", "∞", "<Plug>(copilot-next)", { desc = "Copilot: next suggestion" }) -- <M-,>
    vim.keymap.set("i", "…", "<Plug>(copilot-previous)", { desc = "Copilot: previous suggestion" }) -- <M-;>
  end,
}
