-- Neogit
--
-- A Magit clone for Neovim. This plugins provides a modern UI to interact with Git.

return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- Neogit buffers are not detected by "BufNewFile" or "BufReadPre" event, so to enable plugins
    -- relevant to write commit messages for instance, let's add them manually
    "hrsh7th/nvim-cmp",
    "github/copilot.vim",
  },
  keys = {
    {
      "=",
      function()
        -- If zen-mode is loaded, close it before counting windows as it will be closed anyway
        if package.loaded["zen-mode"] ~= nil then
          require("zen-mode").close()
        end

        -- Open in split window if there are more than one window (i.e. in case of splits)
        -- This fixes the bad behavior when closing Neogit while in a split window
        require("actions").clear_window() -- Remove relative windows to avoid counting them
        local n_windows = #vim.api.nvim_tabpage_list_wins(0)
        if n_windows > 1 then
          require("neogit").open({ kind = "vsplit" })
          return
        end

        require("neogit").open({ kind = "replace" })
      end,
      desc = "Open Neogit buffer",
    },
  },
  opts = {
    disable_hint = true,
    kind = "replace",
    commit_editor = {
      kind = "split",
    },
    commit_view = {
      kind = "split",
    },
    rebase_editor = {
      kind = "split",
    },
  },
  config = function(_, opts)
    require("neogit").setup(opts)

    -- Disable column ruler in Neogit buffers
    vim.api.nvim_command("autocmd FileType Neogit* setlocal colorcolumn=")
  end,
}
