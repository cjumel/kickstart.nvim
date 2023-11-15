-- Neogit
--
-- A Magit clone for Neovim. This plugins provides a modern UI to interact with Git.

return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<leader>g",
      function()
        require("neogit").open()
      end,
      desc = "[G]it buffer",
    },
  },
  opts = {
    disable_hint = true,
    kind = "replace",
    mappings = {
      status = {
        [","] = "GoToPreviousHunkHeader",
        [";"] = "GoToNextHunkHeader",
      },
    },
  },
  config = function(_, opts)
    require("neogit").setup(opts)

    -- Disable column ruler in Neogit buffers
    vim.api.nvim_command("autocmd FileType Neogit* setlocal colorcolumn=")

    -- Fix wrong blue background color in Neogit buffer for non-highlighted hunks
    -- The command `hi NeogitDiffContext` gives `guibg=#b4befe` (blue), whereas the
    -- command `hi NeogitDiffContextHighlight` gives `guifg=#cdd6f4 guibg=#25283b`
    -- Let's set the same colors for both commands to remove the blue background color
    vim.api.nvim_command("hi NeogitDiffContext guifg=#cdd6f4 guibg=#25283b")
  end,
}
