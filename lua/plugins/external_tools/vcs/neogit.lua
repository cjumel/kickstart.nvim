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
    disable_context_highlighting = true,
    kind = "replace",
    mappings = {
      status = {
        [","] = "GoToNextHunkHeader",
        [";"] = "GoToPreviousHunkHeader",
      },
    },
  },
  config = function(_, opts)
    require("neogit").setup(opts)

    -- Disable column ruler in Neogit buffers
    vim.api.nvim_command("autocmd FileType Neogit* setlocal colorcolumn=")
  end,
}
