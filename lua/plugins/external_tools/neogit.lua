-- Neogit
--
-- A Magit clone for Neovim. This plugins provides a modern UI to interact with Git.

-- ISSUE:
-- When Neogit is opened with kind="replace" in a split window and exited, the split window
-- is exited as well, see https://github.com/NeogitOrg/neogit/issues/402

return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "=",
      function()
        require("neogit").open()
      end,
      desc = "Open Neogit buffer",
    },
  },
  opts = {
    disable_hint = true,
    kind = "replace",
  },
  config = function(_, opts)
    require("neogit").setup(opts)

    -- Disable column ruler in Neogit buffers
    vim.api.nvim_command("autocmd FileType Neogit* setlocal colorcolumn=")
  end,
}
