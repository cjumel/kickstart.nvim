-- Copilot.vim
--
-- Vim implementation of GitHub's Copilot.
-- Invoke `:Copilot setup` when using for the first time.

return {
  "github/copilot.vim",
  event = "InsertEnter",
  config = function()
    local AcceptOneWord = function()
      vim.fn["copilot#Accept"]("")
      local bar = vim.fn["copilot#TextQueuedForInsertion"]()
      local word = vim.fn.split(bar, [[[ .]\zs]])[1]
      -- Escape '<', as it causes trouble when inserted (e.g. "<leader>" is inserted as " ")
      -- This doesn't work if escaping '>' as well
      return string.gsub(word, "<", "<lt>")
    end

    vim.keymap.set(
      "i",
      "<s-tab>",
      AcceptOneWord,
      { expr = true, remap = false, desc = "copilot#AcceptOneWord()" }
    )
  end,
}
