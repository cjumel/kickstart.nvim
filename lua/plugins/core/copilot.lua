-- Copilot.vim
--
-- (Neo)Vim plugin for GitHub's Copilot. This plugins uses OpenAI Codex to suggest code completions using virtual text,
-- so it's nicely complementary with floating-window completion tools, like nvim-cmp. However, since the model is not
-- run locally, this plugins require an active internet connection and an active subscription.

return {
  "github/copilot.vim",
  cond = not require("config")["disable_copilot"],
  event = { "BufNewFile", "BufReadPre" }, -- When lazy-loading on InsertEnter, the plugin doesn't work right away
  config = function()
    vim.g.copilot_filetypes = { markdown = true } -- Enable Copilot on additional filetypes

    -- <Tab> is automatically mapped to "accept suggestion"
    vim.keymap.set("i", "<C-]>", "<Plug>(copilot-accept-line)", { desc = "Copilot: accept line" }) -- <C-$>
    vim.keymap.set("i", "<M-CR>", "<Plug>(copilot-accept-word)", { desc = "Copilot: accept word" }) -- <C-CR>
  end,
}
