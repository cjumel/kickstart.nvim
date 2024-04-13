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
    use_default_keymaps = false,
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
    mappings = {
      commit_editor = {
        ["q"] = "Close",
        ["<c-c><c-c>"] = "Submit",
        ["<c-c><c-k>"] = "Abort",
        ["<m-p>"] = "PrevMessage",
        ["<m-n>"] = "NextMessage",
        ["<m-r>"] = "ResetMessage",
      },
      rebase_editor = {
        ["p"] = "Pick",
        ["r"] = "Reword",
        ["e"] = "Edit",
        ["s"] = "Squash",
        ["f"] = "Fixup",
        ["x"] = "Execute",
        ["d"] = "Drop",
        ["b"] = "Break",
        ["q"] = "Close",
        ["<cr>"] = "OpenCommit",
        ["gk"] = "MoveUp",
        ["gj"] = "MoveDown",
        ["<c-c><c-c>"] = "Submit",
        ["<c-c><c-k>"] = "Abort",
      },
      finder = {
        ["<cr>"] = "Select",
        ["<c-c>"] = "Close",
        ["<esc>"] = "Close",
        ["<c-n>"] = "Next",
        ["<c-p>"] = "Previous",
        ["<down>"] = "Next",
        ["<up>"] = "Previous",
        ["<tab>"] = "MultiselectToggleNext",
        ["<s-tab>"] = "MultiselectTogglePrevious",
        ["<c-j>"] = "NOP",
      },
      popup = {
        ["gb"] = "BranchPopup",
        ["gc"] = "CommitPopup",
        ["gf"] = "FetchPopup",
        ["gl"] = "LogPopup",
        ["gsh"] = "StashPopup",
        ["gpl"] = "PullPopup",
        ["gps"] = "PushPopup",
        ["grb"] = "RebasePopup",
        ["grs"] = "ResetPopup",
        ["grv"] = "RevertPopup",
        ["gt"] = "TagPopup",
        ["gw"] = "WorktreePopup",
        ["?"] = "HelpPopup",
      },
      status = {
        ["a"] = "Stage",
        ["A"] = "StageAll",
        ["q"] = "Close",
        ["u"] = "Unstage",
        ["U"] = "UnstageStaged",
        ["x"] = "Discard",
        ["$"] = "CommandHistory",
        ["#"] = "Console",
        ["<CR>"] = "GoToFile",
        ["<Tab>"] = "Toggle",
        ["<C-r>"] = "RefreshBuffer",
        ["<C-v>"] = "VSplitOpen",
        ["<C-x>"] = "SplitOpen",
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
