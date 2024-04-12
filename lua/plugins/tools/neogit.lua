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

        -- Count the number of opened windows
        require("actions").clear_window() -- Remove relative windows to avoid counting them
        local n_windows = #vim.api.nvim_tabpage_list_wins(0)

        -- Open Neogit
        local neogit = require("neogit")
        if n_windows == 1 then -- Simple one window case
          neogit.open()
        else -- Multiple windows case
          -- When using `kind="replace"` with multiple window, opening & closing Neogit buffer will
          -- close the window which was replaced, hence messing up the initial layout
          neogit.open({ kind = "tab" }) -- "tab" is similar to "replace" in slightly less nice
        end
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
