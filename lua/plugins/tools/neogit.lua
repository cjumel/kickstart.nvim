-- Neogit
--
-- A Magit clone for Neovim. This plugins provides a modern UI to interact with Git.

return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- Neogit buffers are not detected by "BufNewFile" or "BufReadPre" event, so to enable
    -- completion (essential for gitmojis), let's add nvim-cmp as a dependency
    "hrsh7th/nvim-cmp",
  },
  keys = {
    {
      "=",
      function()
        -- Determine kind option depending on the number of opened windows (e.g. number of splits)
        -- This fixes the bad behavior when closing Neogit with split windows
        require("actions").clear_window() -- Remove relative windows to avoid counting them
        local n_windows = #vim.api.nvim_tabpage_list_wins(0)

        if n_windows == 1 then
          require("neogit").open({ kind = "replace" })
        else
          require("neogit").open({ kind = "split_above" })
        end
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
