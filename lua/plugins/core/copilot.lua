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
  keys = {
    {
      "<leader>,g",
      function()
        if not vim.g.disable_copilot then
          vim.cmd("Copilot disable")
          vim.g.disable_copilot = true
          vim.notify("GitHub copilot disabled.")
        else
          vim.cmd("Copilot enable")
          vim.g.disable_copilot = false
          vim.notify("GitHub copilot enabled.")
        end
      end,
      desc = "Settings: toggle [G]itHub Copilot",
    },
  },
  config = function()
    vim.g.copilot_filetypes = { -- Enable or disable on some file types
      markdown = true,
    }

    -- The plugin sets <C-i> (<Tab>) as the regular completion key
    vim.keymap.set(
      "i",
      "<C-]>", -- <C-$>
      "<Plug>(copilot-accept-word)",
      { desc = "Copilot: accept one word" }
    )
    vim.keymap.set(
      "i",
      "<C-\\>", -- <C-`>
      "<Plug>(copilot-accept-line)",
      { desc = "Copilot: accept one line" }
    )
  end,
}
