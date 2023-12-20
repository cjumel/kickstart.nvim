-- Copilot.vim
--
-- Vim implementation of GitHub's Copilot.
-- Invoke `:Copilot setup` when using for the first time.

return {
  "github/copilot.vim",
  event = { "BufNewFile", "BufReadPre" },
  config = function()
    vim.g.copilot_filetypes = { -- Enable or disable on some file types
      markdown = true,
    }

    -- <Tab> is the regular completion key
    vim.keymap.set("i", "<S-Tab>", "<Plug>(copilot-accept-word)")
  end,
}
