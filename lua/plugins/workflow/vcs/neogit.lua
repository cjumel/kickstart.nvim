-- Neogit
--
-- A Magit clone for Neovim. This plugins provides a modern UI to interact with Git.

return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
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
  },
  opts = {
    disable_hint = true,
    disable_context_highlighting = true,
    kind = "replace",
    integrations = {
      diffview = true,
    },
    mappings = {
      status = {
        [","] = "GoToPreviousHunkHeader",
        [";"] = "GoToNextHunkHeader",
      },
    },
  },
}
