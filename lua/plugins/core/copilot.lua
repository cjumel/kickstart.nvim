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

    -- The plugin sets many keymaps in insert mode, the useful ones being:
    -- - <Tab> as the regular completion key
    -- - <C-]> to dismiss the suggestion
    vim.keymap.set("i", "<S-Tab>", "<Plug>(copilot-accept-word)")
  end,
}
