-- Neogit
--
-- A Magit clone for Neovim. This plugins provides a modern UI to interact with Git.

return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "sindrets/diffview.nvim",
  },
  keys = {
    {
      "<leader>gs",
      function()
        require("neogit").open()
      end,
      desc = "[G]it: [S]tatus",
    },
    -- Telescope Git features
    {
      "<leader>gb",
      function()
        require("telescope.builtin").git_branches({ layout_strategy = "vertical" })
      end,
      desc = "[G]it: [B]ranches",
    },
    {
      "<leader>gl",
      function()
        require("telescope.builtin").git_commits({
          layout_strategy = "vertical",
          initial_mode = "normal",
        })
      end,
      desc = "[G]it: [L]og",
    },
  },
  opts = {
    disable_hint = true,
    kind = "replace",
    integrations = {
      telescope = true,
      diffview = true,
    },
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
