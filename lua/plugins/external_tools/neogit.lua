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
  },
  config = function(_, opts)
    require("neogit").setup(opts)

    -- Disable column ruler in Neogit buffers
    vim.api.nvim_command("autocmd FileType Neogit* setlocal colorcolumn=")
    -- Improve Neogit buffer context hightlight to make current hunk background text more visible
    vim.api.nvim_command("hi NeogitDiffContextHighlight guifg=#cdd6f4 guibg=#1e1e2e")
  end,
}
